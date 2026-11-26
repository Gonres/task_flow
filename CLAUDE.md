# Coding conventions

These guidelines explain the code design rules.


### General conventions

* DO follow the [Dart package layout
  conventions](https://dart.dev/tools/pub/package-layout).
* DO follow SOLID principles. Write short functions and compact classes.
* DON'T introduce large new external dependencies such as frameworks.

### Naming

Packages:

* AVOID underscores in library package names. Prefer single word names
  or blend words together (e.g. `datetime`).

Files:

* DO put each public widget, class, function, or shared constant in a separate
  file with the corresponding name. For example, put `SignOutButton` in
  `sign_out_button.dart`, `isPostgresConnectionAvailable` in
  `is_postgres_connection_available.dart`, and `testPostgresUrlFiles` in
  `test_postgres_url_files.dart`. Private helpers may share the file of the
  public declaration they support and must be prefixed with an underscore.
* DO prefix files and directories that are not meant to be used from outside of
  current directory with underscore.

Widgets:

  * DO store keys in `static const Key` public variable so they can be
    referenced from tests.
  * DO add a suffix to widget name to indicate what it does and how it looks
    like. Each widget should have one of the following suffixes.
    * `Tile` represent a repeated item in a ListView or similar structure.
    * `Panel` is a collection of different widgets in a rectangular area.
    * `Text` shows a label, e.g. `TitleMediumText`.
    * `Button` is a clickable button, e.g. `SignOutButton`,
      `AccountButton`.
    * `Field` is a form field.
      * `FormField` suffix indicates that the field belongs to a
        `FormBuilderForm` form.
      * `StandaloneField` suffix is for fields that immediately apply all edits.
      They are not placed in a form.
      * `ImmutableField` suffix indicates a field that is for viewing only. It's
        also not a part of a `FormBuilderForm` form.
      * If one field has multiple variants, e.g. a date interval has
        `DateIntervalFormField` and `DateIntervalStandaloneField`, these two
        should look (nearly) the same on screen.
    * `Icon` is an icon or image that is part of app's user interface.
    * `Switch` toggles the selection of an item on or off.
    * `List` shows a list of items.
    * `Pane` is a body region that groups the screen UI.
      * `SmallPane` is a body region for mobile screen sizes.
      * `MediumPane` is a body region for tablet and desktop screen sizes.
      * `ExpandedPane` is a body region for large display screen sizes.
    * `Screen` contains entire screen that shows approproate panes
      according to screen size.
    * `Dialog` is a dialog, a full screen dialog, or adaptive dialog. It can be
      modal or non-modal.
    * `Placeholder` is a widget meant to fill an otherwise empty space, e.g.
      when a list is empty or there are currently no data to be displayed.
    * `Block` for a PDF document widget.

Providers:

Repositories:

  * Methods that return `FutureResult<List<T>>` or `FutureResult<Iterable<T>>`
    should have a prefix `list`. If it takes search criteria, it should have a
    prefix `search` instead of `list`.
  * Methods that return `Stream<List<T>>` or `Stream<Iterable<T>>` should have a
    prefix `stream`.
  * Methods that return a single item should return a nullable type and return
    null when item is not found in the database.
  * Methods that return `FutureResult<Entity?>` should have a prefix `get`.
  * Methods that return `Stream<Entity?>` should have a prefix `stream`.
  * Methods that return only active (not-deleted) items should have a suffix
    `Active`, for deleted items the suffix is `Deleted`, and for both active and
    deleted it's `Combined`.

Classes:

* If there is a conflict with imported package's class name, either DO
  hide the name from the imported package, or DO prefix the class name with
  `Better`.
* If you are fixing an existing class from external package, DO use the same
  class name prefixed with `Better`.
* Classes that require a `SecurityContext` in methods MIGHT use the class name
  prefix `Secured`.
* Acronyms and contractions of compound words DO count as one word. For
  instance, a class should be called `HtmlParser` and not `HTMLParser`.
* Use primary constructors if possible.
* Use in-body constructors instead of primary if a class already has long
  generic type parameters, extends, with, and implements clauses, adding a large parameter list makes the header hard to read. So if a class has extends or implements or with ... use in-body constructor.

Methods:

* If a method is meant to be used only for testing and carefully selected
  use-cases, for example because it avoids security checks, prefix the method
  name with `internal`. Also start the method comment with `Internal method to`.

Abbreviations:

* AVOID using abbreviation in file names, class names, or variable names that
  are not listed below.
* DO use the following abbreviations in class names and variables:
  * `ext` for extension (`_ext` in file names, `Ext` suffix in extension names)
  * `dto` for data transfer object (`_dto` in file names, `Dto` suffix in class
    names)
  * `id` for identifier.
  * `fn` for functions (`typedef ShowProgressFn = void Function(int);`).
* DO use the following abbreviations in directory names to shorten includes and
  paths:
  * `app` for application
  * `dto` for data transfer object
  * `impl` for implementation
  * `infra` for infrastructure
  * `ui` for user interface

Variables:

* DO prefix private variable names with underscores. It's helpful for
  development. If an underscored variable is accidentally unused, analyzer
  reports a warning. There is no warning for variables without underscore
  prefix.

Server:

  * DO add a `handle` prefix all middleware functions to distinguish them from
    regular functions.
  * DO add a HTTP method prefix, such as `get` or `post`, to all handler
    functions to distinguish them from regular functions.

### Code flow

* AVOID using expression body (`=>`) if the whole expression doesn't fit in a
  single line. Convert the code to block body.
* AVOID using nested function definitions. DO NOT define a function inside
  another function. Define all functions in the top-level scope instead and
  prefix private functions with an underscore.

### Stateless widgets

* DON'T create `GlobalKey` in `StatelessWidget.build` method. Convert the widget
  to `StatefulWidget` and create the key in `State`. GlobalKey defined in the
  build method causes unnecessary rebuilds of the widget tree.
* DON'T create `TextEditingController` in stateless widgets. Convert the widget
  to `StatefulWidget` and call `TextEditingController.dispose` from
  `State.dispose`.
* DON'T create `FocusNode` in stateless widgets. Convert the widget to
  `StatefulWidget` and call `FocusNode.dispose` from `State.dispose`.


### Code comments

* DO document every class with a `///` comment.
* DO document every non-trivial method, function, getter, and constructor with
  a `///` comment, whether it is public or private (`_name`). This includes
  private top-level functions, and local functions in existing code, although
  [Code flow](#code-flow) avoids them in new code. A reader should understand
  what the member does, and why, without reading its body.
* The following members are trivial and may stay undocumented:
  * Overrides whose behavior is fully described by the overridden member, such
    as `build`, `toString`, `==`, and `hashCode`.
  * Simple getters and one-line forwarding methods whose name says
    everything.
  * Generated code.
* DO say in the comment what the member does and returns, its side effects,
  notable preconditions or failures, and the reason for non-obvious behavior.
* DON'T restate the member name or its signature.

  Bad: the comment repeats the name and adds nothing.

  ```dart
  /// Finds the expense group.
  Result<ExpenseGroup?> _findExpenseGroup(Id id) { ... }
  ```

  Good: the comment says what is returned and when it fails.

  ```dart
  /// Returns the active expense group with [id] owned by the current user, or
  /// null when it doesn't exist. Fails when the group belongs to another
  /// user, so that callers can't link groups of other users.
  Result<ExpenseGroup?> _findExpenseGroup(Id id) { ... }
  ```

* Remove unused and commented-out code.
* DO place comments above annotations placed on classes, functions, or
  variables.
