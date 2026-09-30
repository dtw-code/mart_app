# App Development & Architecture Guidelines

## Core Tech Stack
* **Framework:** Flutter (Targeting smooth 60/120 FPS performance on common Android devices)
* **Backend & Auth:** Supabase (`supabase_flutter`)
* **State Management:** `provider`
* **Routing:** `go_router` (configured in `nav.dart`)

---

## Project Structure & Folder Responsibility

You MUST strictly follow this folder hierarchy. Do not create new top-level directories under `lib/`.
lib/
┣ models/           # Pure Data Models (JSON parsing, Supabase table mappings)
┣ services/         # Raw API calls, Supabase database queries, network requests
┣ state/            # Provider classes (Business logic, state management)
┣ supabase/         # Supabase client initialization & database credentials/constants
┣ ui/               # All visual presentation code
┃ ┣ components/     # Reusable UI widgets (buttons, cards, search bars, inputs)
┃ ┣ designs/        # UI design specs, themes, color constants, typography styles
┃ ┗ screens/        # Full app screens (Home, Cart, Category, Profile)
┣ utils/            # Helper functions, formatters (currency, dates), constants
┣ main.dart         # Entry point, initializes Supabase and app-wide Providers
┗ nav.dart          # App router configuration (go_router setup)

### Folder Breakdown

* **`models/`**: Define raw Dart classes representing your database tables (e.g., `product_model.dart`, `cart_item_model.dart`). Include `fromJson()` and `toJson()` methods here.
* **`services/`**: Repositories and service classes that communicate directly with Supabase. No UI code allowed here.
* **`state/`**: Provider classes (e.g., `CartProvider`, `HomeProvider`). They listen to user actions, call methods from `services/`, update data, and invoke `notifyListeners()`.
* **`supabase/`**: Contains the Supabase client instance (`supabase.client`) and helper functions for database configuration.
* **`ui/components/`**: Atomic, highly modular widgets shared across screens.
* **`ui/designs/`**: Theme definitions, color palettes, spacing variables, and typography styles.
* **`ui/screens/`**: High-level page widgets that assemble smaller components into complete viewports.
* **`utils/`**: Universal pure helper functions (e.g., price formating `$12.99`, date formatting).

---

## Code Quality & Architecture Rules

### 1. High Component Reusability
* **Never duplicate code:** If a UI element appears more than once (e.g., a primary button, product card, custom text field), extract it into `ui/components/`.
* **Parameterize components:** Make reusable widgets customizable using parameters (e.g., passing `onTap`, `title`, `isLoading` flags).
* **Composition over Big Widgets:** Break large screens into smaller widget components rather than creating one massive `build()` method.

### 2. Clean Code & Separation of Concerns
* **UI belongs ONLY in `ui/`:** Widgets must only handle rendering and local animations. Never put database calls or complex business calculations directly inside `Widget build()`.
* **No Material imports in State/Services:** Classes in `state/` and `services/` must pure Dart logic and must not depend on `BuildContext` unless strictly necessary.
* **Private Helper Widgets:** If a sub-widget is unique to a single screen and not reusable across the app, split it into a private `StatelessWidget` within that screen file rather than creating a deeply nested method returning `Widget`.

---

## Performance & Smooth Execution Guidelines

To ensure the app runs fast on everyday Android phones without dropped frames or lag, follow these strict execution rules:

### 1. Rebuild Minimization
* **Use `const` Constructors:** Mark all static widgets, paddings, borders, and text styles with `const`. This prevents Flutter from rebuilding unmodified subtrees.
* **Targeted Consumer Updates:** Use `Consumer<T>` or `context.select()` inside `Widget build()` to listen only to specific changes in Provider, preventing entire screen rebuilds on small state updates.
* **Avoid unnecessary setState:** Prefer using `Provider` state changes over calling `setState()` on high-level parent widgets.

### 2. Efficient List Rendering
* **Always use `.builder` constructors:** For long dynamic lists or grids, ALWAYS use `ListView.builder` or `GridView.builder`. Never use default `ListView(children: [])` or `SingleChildScrollView` with large `Column`s, as they render off-screen elements in memory simultaneously.
* **Memory Management:** Give explicit `itemCount` values and use `const` item delegates where possible.

### 3. Image Optimization
* **Network Caching:** Always use `cached_network_image` for images fetched from Supabase Storage to prevent redownloading images during scrolling.
* **Sizing Restrictions:** Provide explicit `width` and `height` constraints on image containers to avoid layout shifts while images load.

### 4. Asynchronous Data Handling
* **Non-Blocking UI:** Always display an appropriate loading indicator (e.g., skeleton shimmer or spinner) when waiting for Supabase responses.
* **Error Handling:** Wrap all `services/` calls in `try-catch` blocks and expose human-readable error messages to the UI.







