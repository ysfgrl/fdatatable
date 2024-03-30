part of 'fdatatable.dart';

class FDTFooter<DType extends Object> extends StatelessWidget{

  final FDTTranslation translation;
  const FDTFooter({super.key,
    required this.translation
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<FDTNotifier<DType>>(
      builder: (context, state, child) {
        switch(state.size){
          case FDTSize.sm: return _sm(context, state);
          case FDTSize.md:
          case FDTSize.lg:
          case FDTSize.xl:
          case FDTSize.xxl:
            return _large(context, state);
        }

      },
    );
  }

  Widget _sm(BuildContext context, FDTNotifier state){
    return Padding(
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            tooltip: translation("fdt.previousPage"),
            splashRadius: 20,
            icon: const Icon(Icons.keyboard_arrow_left_rounded,),
            onPressed:() => state.previousPage(),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(translation("fdt.pageSize")),
                const SizedBox(width: 10),
                ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 70, maxHeight: 30),
                    child: DropdownButtonFormField<int>(
                      value: 10,
                      decoration: const InputDecoration(
                          isCollapsed: true,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 6, vertical: 4),
                          border: OutlineInputBorder()),
                      style: const TextStyle(fontSize: 14),
                      onChanged:(value) => state.setPageSize(value!),
                      items: const [
                        DropdownMenuItem(value: 10,child: Text("10"),),
                        DropdownMenuItem(value: 20,child: Text("20"),),
                        DropdownMenuItem(value: 50,child: Text("50"),),
                        DropdownMenuItem(value: 100,child: Text("100"),),
                      ],
                    )
                ),
                SizedBox(width: 10,),
                Column(
                  children: [
                    Row(
                      children: [
                        Text("${translation("fdt.pageNumber")} :"),
                        Text(state.responseModel.page.toString()),
                      ],
                    ),Row(
                      children: [
                        Text("${translation("fdt.totalItems")} :"),
                        Text(state.responseModel.total.toString()),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: translation("fdt.nextPage"),
            splashRadius: 20,
            icon: const Icon(Icons.keyboard_arrow_right_rounded,),
            onPressed: () => state.nextPage(),
          )
        ],
      ),
    );
  }

  Widget _large(BuildContext context, FDTNotifier state){
    Widget child = Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(translation("fdt.pageSize")),
          const SizedBox(width: 5),
          ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 70,),
              child: DropdownButtonFormField<int>(
                value: state.requestModel.pageSize,
                decoration: const InputDecoration(
                    isCollapsed: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 6, vertical: 8),
                    ),
                style: const TextStyle(fontSize: 14),
                onChanged:(value) => state.setPageSize(value!),
                items: const [
                  DropdownMenuItem(value: 10, child: Text("10"),),
                  DropdownMenuItem(value: 20, child: Text("20"),),
                  DropdownMenuItem(value: 50,child: Text("50"),),
                  DropdownMenuItem(value: 100,child: Text("100"),),
                ],
              )
          ),
          const SizedBox(width: 5,),
          Text("${translation("fdt.pageNumber")} :"),
          Text(state.responseModel.page.toString()),
          const SizedBox(width: 5,),
          Text("${translation("fdt.totalItems")} :"),
          Text(state.responseModel.total.toString()),
          const SizedBox(width: 5,),
          IconButton(
            tooltip: translation("fdt.previousPage"),
            splashRadius: 20,
            icon: const Icon(Icons.keyboard_arrow_left_rounded,),
            onPressed:() => state.previousPage(),
          ),
          const SizedBox(width: 5),
          IconButton(
            tooltip: translation("f.next"),
            splashRadius: 20,
            icon: const Icon(Icons.keyboard_arrow_right_rounded,),
            onPressed: () => state.nextPage(),
          )
        ],
      ),
    );
    return child;
  }



}