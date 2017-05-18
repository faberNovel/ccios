# ccios
Xcode File Generator for Clean Code architecture

# How to install

```
cd ccios
gem build ccios.gemspec
gem install ./ccios-x.x.x.gem
```

# How to use

For now there is only one generation possible.

Go to your `.xcodeproj` folder `cd /paht/to/my/xcodeproj`.
Then generate files with prefix `Example`:

```
ccios [-p|-f] Example
```

`-p` stands for `presenter`, `-f` for `full` (meaning presenter and presenter delegate).

This generates 4 files: `ExampleViewController`, `ExampleViewContract`, `ExamplePresenter`, `ExamplePresenterImplementation`. If the `-f` option is used the protocol `ExamplePresenterDelegate` will be generated.

What's more it prints the code you need to add to `DependencyProvider.swift` and `PresenterAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- App/
|   +-- Example/
|   |   +-- UI/
|   |   |   +-- View/
|   |   |   +-- ViewController/
|   |   |   |   +-- ExampleViewController
|   |   |   +-- ExampleViewContract
|   |   +-- Presenter/
|   |   |   +-- ExamplePresenter
|   |   |   +-- ExamplePresenterImplementation
|   |   +-- Model/
```
