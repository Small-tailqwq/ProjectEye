# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 语言提示

务必使用简体中文用作与用户交流、注释的第一语言

## Project Overview

ProjectEye (护眼小卫士) is a Windows desktop application that implements the 20-20-20 rule for eye health: every 20 minutes, focus on something 20 feet (6 meters) away for 20 seconds. It's built with WPF using .NET Framework 4.5 and C#.

## Build and Development Commands

### Building the Project

```bash
# Restore NuGet packages for all projects
cd "src/Local/ProjectEye"
dotnet restore "ProjectEye.Local.sln"

# Build the entire solution
dotnet build "ProjectEye.Local.sln"

# Build specific project
dotnet build "ProjectEye.csproj"
```

### Environment Setup

- Requires .NET Framework 4.5+ runtime
- Uses Entity Framework 6 with SQLite for data persistence
- Mixed package management: PackageReference and packages.config
- All projects have Microsoft.NETFramework.ReferenceAssemblies added for modern build compatibility

## Architecture Overview

### Solution Structure

- **ProjectEye** - Main application with WPF UI and core business logic
- **Project1.UI** - Custom UI component library with theming support
- **ProjectEyeUp** - Updater console application
- **ProjectEyeBug** - Bug reporting/diagnostic utility

### Core Architecture Patterns

**Service-Based Architecture**: The application uses a custom dependency injection container (`ServiceCollection`) that manages service instances with automatic initialization.

Key services include:

- `MainService` - Core timer logic and eye rest reminders
- `TrayService` - System tray integration and notifications
- `StatisticService` - Usage tracking and data persistence
- `ConfigService` - Application settings management
- `TomatoService` - Pomodoro timer functionality
- `ThemeService` - UI theming and customization
- `ScreenService` - Multi-monitor support

**MVVM Pattern**: Views use ViewModels with `INotifyPropertyChanged` implementation. ViewModels are located in `ViewModels/` directory.

**Database Layer**: Uses Entity Framework 6 Code First with SQLite:

- `StatisticContext` - DbContext for usage statistics
- `SQLiteConfiguration` - EF configuration for SQLite
- Database file: `Data/data.db`

### Key Components

**Timer System**: Multiple `DispatcherTimer` instances handle:

- Work timer (eye rest intervals)
- Leave detection (when user steps away)
- Usage tracking
- Date change detection

**Window Management**:

- `TipWindow` - Full-screen rest reminder overlay
- `OptionsWindow` - Settings and configuration
- `StatisticWindow` - Usage statistics and reporting
- `TipViewDesignWindow` - WYSIWYG customization of reminder UI

**Theme System**: Supports multiple themes (Default, Dark, Blue, Pink) with XAML resource dictionaries in `Resources/Themes/`.

## Development Notes

### Common Issues

- Mixed package management: Some projects use PackageReference, others use packages.config
- Build requires Microsoft.NETFramework.ReferenceAssemblies for modern .NET SDK compatibility
- Fody weaving for assembly merging (Costura.Fody) may require manual package restore

### Configuration Files

- `nuget.config` - NuGet package source configuration
- `FodyWeavers.xml` - Assembly weaving configuration for embedding dependencies

### Database Migrations

The app uses Entity Framework Code First. Database is created automatically on first run in `Data/data.db`.

### Localization

Supports Chinese and English with XAML resource dictionaries in `Resources/Language/`.

### Debugging

- Main executable outputs to `bin/Debug/ProjectEye.exe`
- All satellite projects output to main project's bin directory
- Use Visual Studio or VS Code with C# extension for debugging

### Testing

No formal test suite is present. Testing is primarily manual through the application UI.
