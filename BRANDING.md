# FloatMic Branding Guide

## Overview
FloatMic is a professional macOS application for instant speech-to-text transcription. The branding emphasizes simplicity, reliability, and modern design principles.

## Brand Values
- **Simplicity**: Clean, uncluttered interface
- **Reliability**: Consistent performance across all transcription services
- **Privacy**: On-device processing with Apple Intelligence
- **Efficiency**: Quick access and instant results

## Visual Identity

### Color Palette
- **Primary Blue**: `#0066FF` (RGB: 0, 102, 255)
- **Secondary Blue**: `#0C6697` (RGB: 12, 102, 151)
- **Light Blue**: `#4A9EFF` (RGB: 74, 158, 255)
- **Success Green**: `#34C759` (RGB: 52, 199, 89)
- **Warning Orange**: `#FF9500` (RGB: 255, 149, 0)
- **Error Red**: `#FF3B30` (RGB: 255, 59, 48)
- **Neutral Gray**: `#8E8E93` (RGB: 142, 142, 147)

### Typography
- **Primary Font**: SF Pro Display (system font)
- **Secondary Font**: SF Pro Text (system font)
- **Monospace**: SF Mono (for code/technical content)

### Iconography
- **Primary Symbol**: `mic.circle.fill` (SF Symbol)
- **Recording State**: `mic.fill` with red accent
- **Settings**: `gear` or `slider.horizontal.3`
- **History**: `clock` or `list.bullet`
- **Export**: `square.and.arrow.up`

## App Icon Design

### Main App Icon
- **Style**: Blue gradient background with white microphone symbol
- **Shape**: Rounded rectangle (20px corner radius)
- **Symbol**: `mic.circle.fill` in white
- **Background**: Linear gradient from `#0066FF` to `#0C6697`
- **Shadow**: Subtle drop shadow for depth

### Menu Bar Icon
- **Style**: Minimal white circle with black microphone
- **Size**: 18x18 pixels
- **Background**: White circle with subtle shadow
- **Symbol**: `mic.fill` in black
- **Purpose**: Clean, unobtrusive menu bar presence

## UI Design Principles

### Layout
- **Spacing**: Consistent 8px grid system
- **Padding**: 16px standard, 12px compact
- **Corner Radius**: 8px for cards, 4px for buttons
- **Shadows**: Subtle elevation with 2px blur

### Components

#### Floating Mic Button
- **Size**: 100x100 points
- **Style**: Circular with gradient background
- **States**: 
  - Idle: Blue gradient with white mic icon
  - Recording: Red gradient with pulsing animation
  - Processing: Blue gradient with spinner

#### Toast Notifications
- **Style**: Rounded rectangle with shadow
- **Background**: System background with border
- **Duration**: 3 seconds auto-dismiss
- **Animation**: Slide in from top

#### Modal Windows
- **Style**: Clean white background with subtle border
- **Corner Radius**: 12px
- **Shadow**: Multi-layer shadow for depth
- **Size**: Responsive, max 800px width

## Brand Voice

### Tone
- **Professional**: Clear, concise communication
- **Helpful**: Proactive guidance and error messages
- **Confident**: Reliable performance messaging
- **Accessible**: Plain language, no jargon

### Messaging Examples
- **Success**: "Transcription copied to clipboard"
- **Error**: "Unable to transcribe. Please check your microphone permissions."
- **Guidance**: "Configure API keys in Preferences for cloud transcription"

## Implementation Guidelines

### Do's
- Use system fonts and colors when possible
- Maintain consistent spacing and alignment
- Provide clear visual feedback for all actions
- Use SF Symbols for consistency
- Follow macOS Human Interface Guidelines

### Don'ts
- Don't use custom fonts unless necessary
- Don't overload the interface with colors
- Don't use non-standard UI patterns
- Don't ignore accessibility guidelines
- Don't create inconsistent visual hierarchy

## File Structure
```
FloatMic/
├── Assets.xcassets/
│   ├── AppIcon.appiconset/     # App icons (16x16 to 512x512)
│   ├── AccentColor.colorset/   # Brand accent color
│   └── menu_icon.png          # Menu bar icon
├── Branding/
│   ├── logo-variations/       # Different logo treatments
│   ├── color-swatches/        # Color palette files
│   └── typography/           # Font specifications
└── Documentation/
    ├── BRANDING.md           # This file
    └── UI-GUIDELINES.md      # Detailed UI specifications
```

## Usage Guidelines

### Logo Usage
- Always maintain aspect ratio
- Use on light backgrounds when possible
- Minimum size: 32x32 pixels
- Clear space: 1x icon height on all sides

### Color Usage
- Primary blue for main actions and highlights
- Secondary blue for gradients and accents
- System colors for standard UI elements
- Semantic colors for status (success, warning, error)

### Icon Usage
- Prefer SF Symbols over custom icons
- Use consistent sizing (16pt, 20pt, 24pt)
- Maintain visual weight consistency
- Use filled variants for active states

## Future Considerations

### Potential Updates
- Dark mode optimization
- Custom icon sets for different themes
- Animated logo variations
- Branded splash screen
- Custom cursor designs

### Accessibility
- High contrast mode support
- VoiceOver optimization
- Keyboard navigation
- Reduced motion preferences
- Color-blind friendly palette

---

*This branding guide should be updated as the app evolves and new design patterns emerge.*
