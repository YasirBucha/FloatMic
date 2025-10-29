#!/bin/bash

# Simple Xcode Project Creator
echo "🎯 Creating Simple FloatMic Project"
echo "==================================="

# Create a basic project structure
mkdir -p FloatMic.xcodeproj

# Create a minimal but working project.pbxproj
cat > FloatMic.xcodeproj/project.pbxproj << 'EOF'
// !$*UTF8*$!
{
	archiveVersion = 1;
	classes = {
	};
	objectVersion = 56;
	objects = {

/* Begin PBXBuildFile section */
		A1234567890ABCDEF001 /* FloatMicApp.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF000 /* FloatMicApp.swift */; };
		A1234567890ABCDEF003 /* ContentView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF002 /* ContentView.swift */; };
		A1234567890ABCDEF005 /* Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF004 /* Assets.xcassets */; };
		A1234567890ABCDEF008 /* Preview Assets.xcassets in Resources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF007 /* Preview Assets.xcassets */; };
		A1234567890ABCDEF00A /* AudioRecorder.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF009 /* AudioRecorder.swift */; };
		A1234567890ABCDEF00C /* TranscriptionManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF00B /* TranscriptionManager.swift */; };
		A1234567890ABCDEF00E /* APIManager.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF00D /* APIManager.swift */; };
		A1234567890ABCDEF010 /* ToastView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF00F /* ToastView.swift */; };
		A1234567890ABCDEF012 /* KeychainHelper.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF011 /* KeychainHelper.swift */; };
		A1234567890ABCDEF014 /* AudioUtils.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF013 /* AudioUtils.swift */; };
		A1234567890ABCDEF016 /* WhisperLocalService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF015 /* WhisperLocalService.swift */; };
		A1234567890ABCDEF02B /* AppleIntelligenceService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF02A /* AppleIntelligenceService.swift */; };
		A1234567890ABCDEF02E /* WhisperBridge.mm in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF02D /* WhisperBridge.mm */; };
		A1234567890ABCDEF030 /* TranscriptionHistoryItem.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF02F /* TranscriptionHistoryItem.swift */; };
		A1234567890ABCDEF033 /* TranscriptionHistoryView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF031 /* TranscriptionHistoryView.swift */; };
		A1234567890ABCDEF034 /* ExportHistoryView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF032 /* ExportHistoryView.swift */; };
		A1234567890ABCDEF038 /* Whisper.framework in Frameworks */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF035 /* Whisper.framework */; };
		A1234567890ABCDEF039 /* ggml-base.bin in Resources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF036 /* ggml-base.bin */; };
		A1234567890ABCDEF03A /* menu_icon.png in Resources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF037 /* menu_icon.png */; };
		A1234567890ABCDEF018 /* OpenAIWhisperService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF017 /* OpenAIWhisperService.swift */; };
		A1234567890ABCDEF01A /* OpenRouterService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF019 /* OpenRouterService.swift */; };
		A1234567890ABCDEF01C /* GeminiService.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF01B /* GeminiService.swift */; };
		A1234567890ABCDEF01E /* TranscriptionResponse.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF01D /* TranscriptionResponse.swift */; };
		A1234567890ABCDEF020 /* APIKey.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF01F /* APIKey.swift */; };
		A1234567890ABCDEF022 /* AppDelegate.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF021 /* AppDelegate.swift */; };
		A1234567890ABCDEF024 /* ModelSelectionView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF023 /* ModelSelectionView.swift */; };
		A1234567890ABCDEF026 /* APIKeysView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF025 /* APIKeysView.swift */; };
		A1234567890ABCDEF028 /* PreferencesView.swift in Sources */ = {isa = PBXBuildFile; fileRef = A1234567890ABCDEF027 /* PreferencesView.swift */; };
/* End PBXBuildFile section */

/* Begin PBXFileReference section */
		A1234567890ABCDEF000 /* FloatMicApp.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = FloatMicApp.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF002 /* ContentView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ContentView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF004 /* Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = Assets.xcassets; sourceTree = "<group>"; };
		A1234567890ABCDEF007 /* Preview Assets.xcassets */ = {isa = PBXFileReference; lastKnownFileType = folder.assetcatalog; path = "Preview Assets.xcassets"; sourceTree = "<group>"; };
		A1234567890ABCDEF009 /* AudioRecorder.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AudioRecorder.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF00B /* TranscriptionManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TranscriptionManager.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF00D /* APIManager.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = APIManager.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF00F /* ToastView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ToastView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF011 /* KeychainHelper.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = KeychainHelper.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF013 /* AudioUtils.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AudioUtils.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF015 /* WhisperLocalService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = WhisperLocalService.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF017 /* OpenAIWhisperService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = OpenAIWhisperService.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF019 /* OpenRouterService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = OpenRouterService.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF01B /* GeminiService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = GeminiService.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF02A /* AppleIntelligenceService.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppleIntelligenceService.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF02C /* WhisperBridge.h */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.c.h; path = WhisperBridge.h; sourceTree = "<group>"; };
		A1234567890ABCDEF02D /* WhisperBridge.mm */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.cpp.objcpp; path = WhisperBridge.mm; sourceTree = "<group>"; };
		A1234567890ABCDEF02F /* TranscriptionHistoryItem.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TranscriptionHistoryItem.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF01D /* TranscriptionResponse.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TranscriptionResponse.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF01F /* APIKey.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = APIKey.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF021 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF023 /* ModelSelectionView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ModelSelectionView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF025 /* APIKeysView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = APIKeysView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF027 /* PreferencesView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = PreferencesView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF031 /* TranscriptionHistoryView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TranscriptionHistoryView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF032 /* ExportHistoryView.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = ExportHistoryView.swift; sourceTree = "<group>"; };
		A1234567890ABCDEF035 /* Whisper.framework */ = {isa = PBXFileReference; lastKnownFileType = wrapper.framework; path = Whisper.framework; sourceTree = "<group>"; };
		A1234567890ABCDEF036 /* ggml-base.bin */ = {isa = PBXFileReference; lastKnownFileType = file; path = "ggml-base.bin"; sourceTree = "<group>"; };
		A1234567890ABCDEF037 /* menu_icon.png */ = {isa = PBXFileReference; lastKnownFileType = image.png; path = menu_icon.png; sourceTree = "<group>"; };
		A1234567890ABCDEFFD /* FloatMic.app */ = {isa = PBXFileReference; explicitFileType = wrapper.application; includeInIndex = 0; path = FloatMic.app; sourceTree = BUILT_PRODUCTS_DIR; };
		A1234567890ABCDEFFE /* FloatMic.entitlements */ = {isa = PBXFileReference; lastKnownFileType = text.plist.entitlements; path = FloatMic.entitlements; sourceTree = "<group>"; };
/* End PBXFileReference section */

/* Begin PBXFrameworksBuildPhase section */
		A1234567890ABCDEFFB /* Frameworks */ = {
			isa = PBXFrameworksBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A1234567890ABCDEF038 /* Whisper.framework in Frameworks */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXFrameworksBuildPhase section */

/* Begin PBXGroup section */
		A1234567890ABCDEFF5 = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEFF6 /* FloatMic */,
				A1234567890ABCDEFFE /* Products */,
			);
			sourceTree = "<group>";
		};
		A1234567890ABCDEFF6 /* FloatMic */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF000 /* FloatMicApp.swift */,
				A1234567890ABCDEF021 /* AppDelegate.swift */,
				A1234567890ABCDEF002 /* ContentView.swift */,
				A1234567890ABCDEF009 /* AudioRecorder.swift */,
				A1234567890ABCDEF00B /* TranscriptionManager.swift */,
				A1234567890ABCDEF00D /* APIManager.swift */,
				A1234567890ABCDEF00F /* ToastView.swift */,
				A1234567890ABCDEF02C /* WhisperBridge.h */,
				A1234567890ABCDEF02D /* WhisperBridge.mm */,
				A1234567890ABCDEF035 /* Whisper.framework */,
				A1234567890ABCDEF036 /* ggml-base.bin */,
				A1234567890ABCDEF037 /* menu_icon.png */,
				A1234567890ABCDEF029 /* Models */,
				A1234567890ABCDEF02B /* Services */,
				A1234567890ABCDEF02C /* Utils */,
				A1234567890ABCDEF02D /* Views */,
				A1234567890ABCDEF004 /* Assets.xcassets */,
				A1234567890ABCDEF006 /* Preview Content */,
				A1234567890ABCDEFFE /* FloatMic.entitlements */,
			);
			path = FloatMic;
			sourceTree = "<group>";
		};
		A1234567890ABCDEFFE /* Products */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEFFD /* FloatMic.app */,
			);
			name = Products;
			sourceTree = "<group>";
		};
		A1234567890ABCDEF006 /* Preview Content */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF007 /* Preview Assets.xcassets */,
			);
			path = "Preview Content";
			sourceTree = "<group>";
		};
		A1234567890ABCDEF029 /* Models */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF01D /* TranscriptionResponse.swift */,
				A1234567890ABCDEF01F /* APIKey.swift */,
				A1234567890ABCDEF02F /* TranscriptionHistoryItem.swift */,
			);
			path = Models;
			sourceTree = "<group>";
		};
		A1234567890ABCDEF02B /* Services */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF02A /* AppleIntelligenceService.swift */,
				A1234567890ABCDEF015 /* WhisperLocalService.swift */,
				A1234567890ABCDEF017 /* OpenAIWhisperService.swift */,
				A1234567890ABCDEF019 /* OpenRouterService.swift */,
				A1234567890ABCDEF01B /* GeminiService.swift */,
			);
			path = Services;
			sourceTree = "<group>";
		};
		A1234567890ABCDEF02C /* Utils */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF011 /* KeychainHelper.swift */,
				A1234567890ABCDEF013 /* AudioUtils.swift */,
			);
			path = Utils;
			sourceTree = "<group>";
		};
		A1234567890ABCDEF02D /* Views */ = {
			isa = PBXGroup;
			children = (
				A1234567890ABCDEF023 /* ModelSelectionView.swift */,
				A1234567890ABCDEF025 /* APIKeysView.swift */,
				A1234567890ABCDEF027 /* PreferencesView.swift */,
				A1234567890ABCDEF031 /* TranscriptionHistoryView.swift */,
				A1234567890ABCDEF032 /* ExportHistoryView.swift */,
			);
			path = Views;
			sourceTree = "<group>";
		};
/* End PBXGroup section */

/* Begin PBXNativeTarget section */
		A1234567890ABCDEFFD /* FloatMic */ = {
			isa = PBXNativeTarget;
			buildConfigurationList = A1234567890ABCDEFFC /* Build configuration list for PBXNativeTarget "FloatMic" */;
			buildPhases = (
				A1234567890ABCDEFFA /* Sources */,
				A1234567890ABCDEFFB /* Frameworks */,
				A1234567890ABCDEFFC /* Resources */,
			);
			buildRules = (
			);
			dependencies = (
			);
			name = FloatMic;
			productName = FloatMic;
			productReference = A1234567890ABCDEFFD /* FloatMic.app */;
			productType = "com.apple.product-type.application";
		};
/* End PBXNativeTarget section */

/* Begin PBXProject section */
		A1234567890ABCDEFF7 /* Project object */ = {
			isa = PBXProject;
			attributes = {
				BuildIndependentTargetsInParallel = 1;
				LastSwiftUpdateCheck = 1500;
				LastUpgradeCheck = 1500;
				TargetAttributes = {
					A1234567890ABCDEFFD = {
						CreatedOnToolsVersion = 15.0;
					};
				};
			};
			buildConfigurationList = A1234567890ABCDEFFA /* Build configuration list for PBXProject "FloatMic" */;
			compatibilityVersion = "Xcode 14.0";
			developmentRegion = en;
			hasScannedForEncodings = 0;
			knownRegions = (
				en,
				Base,
			);
			mainGroup = A1234567890ABCDEFF5;
			productRefGroup = A1234567890ABCDEFFE /* Products */;
			projectDirPath = "";
			projectRoot = "";
			targets = (
				A1234567890ABCDEFFD /* FloatMic */,
			);
		};
/* End PBXProject section */

/* Begin PBXResourcesBuildPhase section */
		A1234567890ABCDEFFC /* Resources */ = {
			isa = PBXResourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A1234567890ABCDEF008 /* Preview Assets.xcassets in Resources */,
				A1234567890ABCDEF005 /* Assets.xcassets in Resources */,
				A1234567890ABCDEF039 /* ggml-base.bin in Resources */,
				A1234567890ABCDEF03A /* menu_icon.png in Resources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXResourcesBuildPhase section */

/* Begin PBXSourcesBuildPhase section */
		A1234567890ABCDEFFA /* Sources */ = {
			isa = PBXSourcesBuildPhase;
			buildActionMask = 2147483647;
			files = (
				A1234567890ABCDEF001 /* FloatMicApp.swift in Sources */,
				A1234567890ABCDEF003 /* ContentView.swift in Sources */,
				A1234567890ABCDEF00A /* AudioRecorder.swift in Sources */,
				A1234567890ABCDEF00C /* TranscriptionManager.swift in Sources */,
				A1234567890ABCDEF00E /* APIManager.swift in Sources */,
				A1234567890ABCDEF010 /* ToastView.swift in Sources */,
				A1234567890ABCDEF012 /* KeychainHelper.swift in Sources */,
				A1234567890ABCDEF014 /* AudioUtils.swift in Sources */,
				A1234567890ABCDEF016 /* WhisperLocalService.swift in Sources */,
				A1234567890ABCDEF02B /* AppleIntelligenceService.swift in Sources */,
				A1234567890ABCDEF02E /* WhisperBridge.mm in Sources */,
				A1234567890ABCDEF030 /* TranscriptionHistoryItem.swift in Sources */,
				A1234567890ABCDEF033 /* TranscriptionHistoryView.swift in Sources */,
				A1234567890ABCDEF034 /* ExportHistoryView.swift in Sources */,
				A1234567890ABCDEF018 /* OpenAIWhisperService.swift in Sources */,
				A1234567890ABCDEF01A /* OpenRouterService.swift in Sources */,
				A1234567890ABCDEF01C /* GeminiService.swift in Sources */,
				A1234567890ABCDEF01E /* TranscriptionResponse.swift in Sources */,
				A1234567890ABCDEF020 /* APIKey.swift in Sources */,
				A1234567890ABCDEF022 /* AppDelegate.swift in Sources */,
				A1234567890ABCDEF024 /* ModelSelectionView.swift in Sources */,
				A1234567890ABCDEF026 /* APIKeysView.swift in Sources */,
				A1234567890ABCDEF028 /* PreferencesView.swift in Sources */,
			);
			runOnlyForDeploymentPostprocessing = 0;
		};
/* End PBXSourcesBuildPhase section */

/* Begin XCBuildConfiguration section */
		A1234567890ABCDEFFD /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = dwarf;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_TESTABILITY = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_DYNAMIC_NO_PIC = NO;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_OPTIMIZATION_LEVEL = 0;
				GCC_PREPROCESSOR_DEFINITIONS = (
					"DEBUG=1",
					"$(inherited)",
				);
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 12.0;
				MTL_ENABLE_DEBUG_INFO = INCLUDE_SOURCE;
				MTL_FAST_MATH = YES;
				ONLY_ACTIVE_ARCH = YES;
				SDKROOT = macosx;
				SWIFT_ACTIVE_COMPILATION_CONDITIONS = "DEBUG $(inherited)";
				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
			};
			name = Debug;
		};
		A1234567890ABCDEFFE /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ALWAYS_SEARCH_USER_PATHS = NO;
				ASSETCATALOG_COMPILER_GENERATE_SWIFT_ASSET_SYMBOL_EXTENSIONS = YES;
				CLANG_ANALYZER_NONNULL = YES;
				CLANG_ANALYZER_NUMBER_OBJECT_CONVERSION = YES_AGGRESSIVE;
				CLANG_CXX_LANGUAGE_STANDARD = "gnu++20";
				CLANG_ENABLE_MODULES = YES;
				CLANG_ENABLE_OBJC_ARC = YES;
				CLANG_ENABLE_OBJC_WEAK = YES;
				CLANG_WARN_BLOCK_CAPTURE_AUTORELEASING = YES;
				CLANG_WARN_BOOL_CONVERSION = YES;
				CLANG_WARN_COMMA = YES;
				CLANG_WARN_CONSTANT_CONVERSION = YES;
				CLANG_WARN_DEPRECATED_OBJC_IMPLEMENTATIONS = YES;
				CLANG_WARN_DIRECT_OBJC_ISA_USAGE = YES_ERROR;
				CLANG_WARN_DOCUMENTATION_COMMENTS = YES;
				CLANG_WARN_EMPTY_BODY = YES;
				CLANG_WARN_ENUM_CONVERSION = YES;
				CLANG_WARN_INFINITE_RECURSION = YES;
				CLANG_WARN_INT_CONVERSION = YES;
				CLANG_WARN_NON_LITERAL_NULL_CONVERSION = YES;
				CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF = YES;
				CLANG_WARN_OBJC_LITERAL_CONVERSION = YES;
				CLANG_WARN_OBJC_ROOT_CLASS = YES_ERROR;
				CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER = YES;
				CLANG_WARN_RANGE_LOOP_ANALYSIS = YES;
				CLANG_WARN_STRICT_PROTOTYPES = YES;
				CLANG_WARN_SUSPICIOUS_MOVE = YES;
				CLANG_WARN_UNGUARDED_AVAILABILITY = YES_AGGRESSIVE;
				CLANG_WARN_UNREACHABLE_CODE = YES;
				CLANG_WARN__DUPLICATE_METHOD_MATCH = YES;
				COPY_PHASE_STRIP = NO;
				DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
				ENABLE_NS_ASSERTIONS = NO;
				ENABLE_STRICT_OBJC_MSGSEND = YES;
				ENABLE_USER_SCRIPT_SANDBOXING = YES;
				GCC_C_LANGUAGE_STANDARD = gnu17;
				GCC_NO_COMMON_BLOCKS = YES;
				GCC_WARN_64_TO_32_BIT_CONVERSION = YES;
				GCC_WARN_ABOUT_RETURN_TYPE = YES_ERROR;
				GCC_WARN_UNDECLARED_SELECTOR = YES;
				GCC_WARN_UNINITIALIZED_AUTOS = YES_AGGRESSIVE;
				GCC_WARN_UNUSED_FUNCTION = YES;
				GCC_WARN_UNUSED_VARIABLE = YES;
				LOCALIZATION_PREFERS_STRING_CATALOGS = YES;
				MACOSX_DEPLOYMENT_TARGET = 12.0;
				MTL_ENABLE_DEBUG_INFO = NO;
				MTL_FAST_MATH = YES;
				SDKROOT = macosx;
				SWIFT_COMPILATION_MODE = wholemodule;
			};
			name = Release;
		};
		A1234567890ABCDEFFF /* Debug */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = FloatMic/FloatMic.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"FloatMic/Preview Content\"";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_NSMicrophoneUsageDescription = "FloatMic needs microphone access to record audio for transcription.";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				FRAMEWORK_SEARCH_PATHS = (
					"$(inherited)",
					"$(SRCROOT)/FloatMic",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.floatmic.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Debug;
		};
		A1234567890ABCDEF00 /* Release */ = {
			isa = XCBuildConfiguration;
			buildSettings = {
				ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon;
				ASSETCATALOG_COMPILER_GLOBAL_ACCENT_COLOR_NAME = AccentColor;
				CODE_SIGN_ENTITLEMENTS = FloatMic/FloatMic.entitlements;
				CODE_SIGN_STYLE = Automatic;
				COMBINE_HIDPI_IMAGES = YES;
				CURRENT_PROJECT_VERSION = 1;
				DEVELOPMENT_ASSET_PATHS = "\"FloatMic/Preview Content\"";
				ENABLE_PREVIEWS = YES;
				GENERATE_INFOPLIST_FILE = YES;
				INFOPLIST_KEY_NSMicrophoneUsageDescription = "FloatMic needs microphone access to record audio for transcription.";
				INFOPLIST_KEY_NSHumanReadableCopyright = "";
				LD_RUNPATH_SEARCH_PATHS = (
					"$(inherited)",
					"@executable_path/../Frameworks",
				);
				FRAMEWORK_SEARCH_PATHS = (
					"$(inherited)",
					"$(SRCROOT)/FloatMic",
				);
				MARKETING_VERSION = 1.0;
				PRODUCT_BUNDLE_IDENTIFIER = com.floatmic.app;
				PRODUCT_NAME = "$(TARGET_NAME)";
				SWIFT_EMIT_LOC_STRINGS = YES;
				SWIFT_VERSION = 5.0;
			};
			name = Release;
		};
/* End XCBuildConfiguration section */

/* Begin XCConfigurationList section */
		A1234567890ABCDEFFA /* Build configuration list for PBXProject "FloatMic" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A1234567890ABCDEFFD /* Debug */,
				A1234567890ABCDEFFE /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
		A1234567890ABCDEFFC /* Build configuration list for PBXNativeTarget "FloatMic" */ = {
			isa = XCConfigurationList;
			buildConfigurations = (
				A1234567890ABCDEFFF /* Debug */,
				A1234567890ABCDEF00 /* Release */,
			);
			defaultConfigurationIsVisible = 0;
			defaultConfigurationName = Release;
		};
/* End XCConfigurationList section */
	};
	rootObject = A1234567890ABCDEFF7 /* Project object */;
}
EOF

echo "✅ Xcode project created!"
echo ""
echo "🎯 Now let's build it:"
echo "1. Open FloatMic.xcodeproj in Xcode"
echo "2. Press Cmd+B to build"
echo "3. Press Cmd+R to run"
echo ""
echo "All files are ready and properly configured!"
