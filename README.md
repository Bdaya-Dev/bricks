# bdaya_bricks

[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)


some mason bricks that we use for our internal workflow

> Note that we use `bdaya_flutter_common` as a base library for the generated code
> We also need `build_runner` as a dev dependency.

* bdaya_form
    - generate a form using `reactive_forms_annotations` + `reactive_forms_generator`
* bdaya_page
    - generate a simple page (view + controller)
* bdaya_route 
    - generate a page that reacts to route changes from `go_router`


## Usage
1. Activate [mason_cli](https://pub.dev/packages/mason_cli)
    - `dart pub global activate mason_cli`
2. Add Bricks
    - bdaya_form    
        ```
        mason add bdaya_form --git-url https://github.com/Bdaya-Dev/bricks --git-path bdaya_form
        ```
    - bdaya_route
        ```
        mason add bdaya_route --git-url https://github.com/Bdaya-Dev/bricks --git-path bdaya_route
        ```
    - bdaya_page
        ```
        mason add bdaya_page --git-url https://github.com/Bdaya-Dev/bricks --git-path bdaya_page
        ```
3. `mason get`
4. Make
    - bdaya_form: 
        ```
        mason make bdaya_form -o lib/src/dialogs --name EditUser
        ```
        > Note that `bdaya_form` requires some dependencies, which you can add using this command:
        >
        > `dart pub add reactive_forms_annotations --dev reactive_forms_generator`
    - bdaya_route:
        ```
        mason make bdaya_route -o lib/src/pages --name UserDetails
        ```
    - bdaya_page:
        ```
        mason make bdaya_page -o lib/src/pages --name Users
        ```

