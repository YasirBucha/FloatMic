import Foundation

#if canImport(Whisper)
import Whisper

extension WhisperLocalService {
    func transcribeWithWhisperFramework(url: URL, modelPath: String) -> String? {
        // Minimal example using C API; production should manage context reuse
        guard let ctx = whisper_init_from_file(modelPath) else { return nil }
        defer { whisper_free(ctx) }

        var params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY)
        params.print_progress = false
        params.translate = false
        params.language = UnsafePointer<Int8>(("en" as NSString).utf8String)

        // Load audio file bytes
        guard let data = try? Data(contentsOf: url) else { return nil }
        // whisper.cpp expects f32 PCM mono; for brevity we rely on internal decoding if available.
        // If not available, integrate an audio decode to f32 PCM.
        let floatCount = data.count / MemoryLayout<Float>.size
        let result: String?
        result = withUnsafeBytes(of: data) { rawBuf -> String? in
            let ptr = rawBuf.bindMemory(to: Float.self)
            if ptr.count == 0 { return nil }
            if whisper_full(ctx, params, ptr.baseAddress, Int32(floatCount)) != 0 { return nil }
            var out = ""
            let n = whisper_full_n_segments(ctx)
            for i in 0..<n {
                if let cstr = whisper_full_get_segment_text(ctx, i) {
                    out += String(cString: cstr)
                }
            }
            return out.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        return result
    }
}
#endif


