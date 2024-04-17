# Flutter Datatable



<p float="left">
  <img src="https://raw.githubusercontent.com/ysfgrl/fdatatable/master/screenshots/Screenshot1.png" alt="drawing" width="200"/>
    <img src="https://raw.githubusercontent.com/ysfgrl/fdatatable/master/screenshots/Screenshot2.png" alt="drawing" width="200"/>
    <img src="https://raw.githubusercontent.com/ysfgrl/fdatatable/master/screenshots/Screenshot3.png" alt="drawing" width="200"/>
    <img src="https://raw.githubusercontent.com/ysfgrl/fdatatable/master/screenshots/Screenshot4.png" alt="drawing" width="200"/>
</p>


## Features

- **Pagination**, 
- **Filtering** 
- Responsible



### Setup

Create a new `FDT<DType>`

- `DType` is the type of your object.


```dart
FDT<Model>(
    fdtRequest: (requestModel) async {
      await Future.delayed(Duration(seconds: 2));
      return FDTResponseModel(
          page: requestModel.page,
          pageSize: requestModel.pageSize,
          total: 100,
          list: _exampleModels(requestModel.pageSize)
      );
    },
    columns: [],
    filters: [],
)
```

### Define your columns

```dart
FDTBaseColumn(
    title: "User Name",
    cellBuilder: (item) => Text(item.userName),
    columnWidth: 50,
    isExpand: true,
)
```

### Define Filters

`FDTFilter<FType>`

- `FType` is the type of filter [String, int, bool, DateTime].

```dart
FDT<Model>(
    filters: [
        FDTTextFilter(
          key: "name",
          val: "initValue",
        ),
    ]
)
```

#####  Filters types

- `FDTTextFilter` 
- `FDTIntFilter` 
- `FDTCheckboxFilter` 
- `FDTDropDownFilter<FType>` 
- `FDTDateFilter`

### Top Menu

```dart
FDT<Model>(
    ...
    topActions: const [
      FDTAction(text: "New",  action: FDTActionTypes.add, icon: Icon(Icons.plus_one_outlined, color: Colors.blue,)),
      FDTAction(text: "Refresh", action: FDTActionTypes.refresh, icon: Icon(Icons.refresh_outlined,)),
      FDTAction(text: "To Page 10", action: FDTActionTypes.toPage, icon: Icon(Icons.arrow_circle_right_outlined,)),
    ]
)
```

### Rows Menu

```dart
FDT<Model>(
    ...
    rowActions: const [
      FDTAction(text: "Edit", action: FDTActionTypes.edit, icon: Icon(Icons.edit,)),
      FDTAction(text: "Delete", action: FDTActionTypes.delete,
          icon: Icon(Icons.delete_forever, color: Colors.red,)
      ),
      FDTAction(text: "İnfo", action: FDTActionTypes.info,
          icon: Icon(Icons.info, color: Colors.red,)
      )
    ],
)
```


## Screenshots

