# ccios
Xcode File Generator for Clean Code architecture

# How to install

```
cd ccios
gem build ccios.gemspec
gem install ./ccios-x.x.x.gem
```

# How to use

Go to your `.xcodeproj` folder `cd /paht/to/my/xcodeproj`.
Then generate files with prefix `Example`:

```
ccios [-p|-i|-r|-c] Example [-d]
```

Generated templates can be found [here](https://github.com/felginep/ccios/tree/master/lib/ccios/templates)

### `-p`
`-p` stands for `presenter`

This generates 4 files: `ExampleViewController`, `ExampleViewContract`, `ExamplePresenter`, `ExamplePresenterImplementation`. If the `-d` option is supplied the protocol `ExamplePresenterDelegate` will be generated.

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

### `-i`
`-i` stands for `interactor`

This generates 2 files: `ExampleInteractor` and `ExampleInteractorImplementation`.

What's more it prints the code you need to add to `InteractorAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- Core/
|   +-- Interactor/
|   |   +-- ExampleInteractor/
|   |   |   +-- ExampleInteractor
|   |   |   +-- ExampleInteractorImplementation
```

### `-r`
`-r` stands for `repository`

This generates 2 files: `ExampleRepository` and `ExampleRepositoryImplementation`.

What's more it prints the code you need to add to `RepositoryAssembly.swift` for dependency injection.

The following structure is created for you in the Xcode project:

```
.
+-- Core/
|   +-- Data/
|   |   +-- Example
|   |   |   +-- ExampleRepository
+-- Data/
|   +-- Example
|   |   +-- ExampleRepositoryImplementation
```

### `-c`
`-c` stands for `coordinator`

This generates one file: `ExampleCoordinator`. If the `-d` option is supplied the protocol `ExampleCoordinatorDelegate` will be generated.

The following structure is created for you in the Xcode project:

```
.
+-- Coordinator/
|   +-- ExampleCoordinator
```
