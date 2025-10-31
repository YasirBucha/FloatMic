import Foundation

#if canImport(Whisper)
import AVFoundation
import Whisper

extension WhisperLocalService {
    func transcribeWithWhisperFramework(url: URL, modelPath: String) -> String? {
        guard let pcmSamples = preparePCMInput(url: url, targetSampleRate: 16_000) else {
            print("WhisperLocalService: unable to decode audio into PCM samples")
            return nil
        }

        guard let ctx = whisper_init_from_file(modelPath) else { return nil }
        defer { whisper_free(ctx) }

        return pcmSamples.withUnsafeBufferPointer { buffer -> String? in
            guard let baseAddress = buffer.baseAddress else { return nil }

            var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
            params.print_progress = false
            params.translate = false

            let status = "en".withCString { langPtr -> Int32 in
                params.language = langPtr
                return whisper_full(ctx, params, baseAddress, Int32(buffer.count))
            }

            guard status == 0 else { return nil }

            var transcript = ""
            let segmentCount = whisper_full_n_segments(ctx)
            for index in 0..<segmentCount {
                if let cString = whisper_full_get_segment_text(ctx, index) {
                    transcript += String(cString: cString)
                }
            }
            return transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        }
    }

    private func preparePCMInput(url: URL, targetSampleRate: Double) -> [Float]? {
        do {
            let file = try AVAudioFile(forReading: url)
            guard let targetFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32,
                                                   sampleRate: targetSampleRate,
                                                   channels: 1,
                                                   interleaved: false) else {
                return nil
            }

            guard let converter = AVAudioConverter(from: file.processingFormat, to: targetFormat) else {
                return nil
            }

            guard let sourceBuffer = AVAudioPCMBuffer(pcmFormat: file.processingFormat,
                                                      frameCapacity: AVAudioFrameCount(file.length)) else {
                return nil
            }
            try file.read(into: sourceBuffer)

            let ratio = targetSampleRate / file.processingFormat.sampleRate
            let outputCapacity = AVAudioFrameCount(Double(sourceBuffer.frameLength) * ratio) + 1
            guard let outputBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat,
                                                      frameCapacity: outputCapacity) else {
                return nil
            }

            var providedInput = false
            var conversionError: NSError?
            let status = converter.convert(to: outputBuffer, error: &conversionError) { _, outStatus in
                if providedInput {
                    outStatus.pointee = .endOfStream
                    return nil
                }
                providedInput = true
                outStatus.pointee = .haveData
                return sourceBuffer
            }

            guard status != .error else {
                if let conversionError = conversionError {
                    print("WhisperLocalService: audio conversion error \(conversionError)")
                }
                return nil
            }

            guard outputBuffer.frameLength > 0,
                  let channelPointer = outputBuffer.floatChannelData else {
                return nil
            }

            let frameCount = Int(outputBuffer.frameLength)
            return Array(UnsafeBufferPointer(start: channelPointer[0], count: frameCount))
        } catch {
            print("WhisperLocalService: failed to prepare PCM input - \(error)")
            return nil
        }
    }
}
#endif

