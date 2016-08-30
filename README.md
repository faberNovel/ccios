# ccios
Xcode File Generator for Clean Code architecture

# How to install

```
cd ccios
gem build ccios.gemspec
gem install ./ccios.gem
```

# How to use

For now there is only one generation possible.

Go to your `.xcodeproj` folder `cd /paht/to/my/xcodeproj`.
Then generate files with prefix `Example`:

```
ccios -p Example
```

This generates 5 files: `ExampleViewController`, `ExampleViewContract`, `ExamplePresenter`, `ExamplePresenterImplementation`, `ExampleComponent`.

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
+-- DI/
|   +-- ExampleComponent
```
