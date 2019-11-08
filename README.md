# ccios
Xcode File Generator for Clean Code architecture

# How to install
```
gem install ccios
```

To build it from source:
```
cd ccios
gem build ccios.gemspec
gem install ./ccios-x.x.x.gem
```

To run the tests run:
```rake test```

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

## Configuration

Each project is different. You can configure the paths on disk, and the groups in the xcodeproj for the new files.

Create a file `.ccios.yml` at the root of your project.

By default, if no file is present, the following configuration will be used:
```
app:
  project: MyProject.xcodeproj
  presenter:
    source: Classes
    group: Classes/App
  coordinator:
    source: Classes
    group: Classes/Coordinator

core:
  project: MyProject.xcodeproj
  interactor:
    source: Classes
    group: Classes/Core/Interactor
  repository:
    source: Classes
    group: Classes/Core/Data

data:
  project: MyProject.xcodeproj
  repository:
    source: Classes
    group: Classes/Data
```

But you could imagine more complex project structures with multiple xcodeproj:
```
app:
  project: MyProject/MyProject.xcodeproj
  presenter:
    source: MyProject/Classes
    group: Classes/App
  coordinator:
    source: MyProject/Classes
    group: Classes/Coordinator

core:
  project: MyProjectCore/MyProjectCore.xcodeproj
  interactor:
    source: MyProjectCore/MyProjectCore/Interactors
    group: MyProjectCore/Interactors
  repository:
    source: MyProjectCore/MyProjectCore/Repository
    group: MyProjectCore/Repository

data:
  project: MyProjectData/MyProjectData.xcodeproj
  repository:
    source: MyProjectData/MyProjectData/Sources/Repositories
    group: MyProjectData/Sources/Repositories

```

