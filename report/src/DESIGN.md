# Design

## System Architecture

The application is composed of three tiers:

1. **Data Extraction Layer** - Responsible for collecting hyperlink data from websites
2. **Processing Layer** - Manages data transformation, caching, and API communication  
3. **Presentation Layer** - Provides the user interface for visualization and interaction

## Frontend Design

The frontend is built as a single-page application using React with TypeScript, leveraging modern web development practices.

### Technology Stack

The frontend utilizes the following key libraries and frameworks:

- **React 19** with TypeScript for component-based UI development
- **React Router DOM** for navigation and history management
- **Tailwind CSS** with Base UI Components for styling
- **TanStack React Query** for API data management and caching
- **markdown-to-jsx** and **remark-gfm** for markdown processing

### Component Structure

The frontend implements:

- **Search Interface**: A simple search bar for URL input, similar to browser address bars
- **Visualization Components**: Graph-based representations of webpage hierarchies  
- **Navigation Controls**: History navigation using keyboard shortcuts (Alt+Arrows)
- **Data Display**: List views and text areas for resource information

### User Interaction Model

User interaction is designed to be intuitive:

- URL input via search bar initiates data retrieval
- Results are displayed in a hierarchical list view
- History navigation enabled through Alt+Left Arrow (previous layer) and Alt+Right Arrow (next layer)
- No novel interaction methods are implemented beyond standard web patterns

## Backend Integration

The frontend communicates with backend services through RESTful APIs, utilizing React Query for:

- Data fetching and caching
- Error handling
- Loading state management
- Browser history integration for navigation stack

## Implementation Approach

The system is designed to be:

- **Modular**: Each component can be developed and tested independently
- **Extensible**: New visualization types and data sources can be added
- **Maintainable**: Clear separation of concerns with well-defined interfaces
- **Portable**: Based on web standards for cross-platform compatibility

## Data Flow

1. User enters URL in search bar
2. Frontend sends request to backend API
3. Backend processes extraction and returns hierarchical data
4. Frontend displays results using React components
5. User navigates through history using keyboard shortcuts
6. All data is cached for performance optimization