import sys
import os

# 将短横线转换小驼峰
def camel_case(s):
    ss = s.split('_')
    for i in range(1, len(ss)):
        ss[i] = ss[i].capitalize()
    return ''.join(ss)

def bindings_file(folder_name):
    # 转为大驼峰
    folderName = camel_case(folder_name.capitalize())
    return f"""import 'package:get/get.dart';

import '../controllers/{folder_name}_controller.dart';

class {folderName}Binding extends Binding {{
  @override
  List<Bind> dependencies() {{
    return [
      Bind.lazyPut<{folderName}Controller>(
        () => {folderName}Controller(),
      )
    ];
  }}
}}
"""

def controllers_file(folder_name):
    # 首字母大写
    folderName = camel_case(folder_name.capitalize())
    return f"""import 'package:get/get.dart';

class {folderName}Controller extends GetxController {{
  
}}
"""

def views_file(folder_name):
    # 首字母大写
    folderName = camel_case(folder_name.capitalize())
    return f"""import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/{folder_name}_controller.dart';

class {folderName}View extends GetView<{folderName}Controller> {{
    const {folderName}View({{super.key}});

  @override
  Widget build(BuildContext context) {{
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () => Get.back(),
          ),
          title: Text('{folderName}'),
      ),
      body: Center(
        child: Text(
        '{folderName}View is working',
        style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }}
}}
"""


def create_project_structure(relative_path, folder_name):
    base_path = os.path.join(relative_path, folder_name)
    subfolders = ['bindings', 'controllers', 'views']
    
    try:
        os.makedirs(base_path, exist_ok=True)
        for subfolder in subfolders:
            subfolder_path = os.path.join(base_path, subfolder)
            os.makedirs(subfolder_path, exist_ok=True)
            file_path = os.path.join(subfolder_path, f"{folder_name}_{subfolder[:-1]}.dart")
            with open(file_path, 'w') as file:
                if subfolder == 'bindings':
                    file.write(bindings_file(folder_name))
                elif subfolder == 'controllers':
                    file.write(controllers_file(folder_name))
                elif subfolder == 'views':
                    file.write(views_file(folder_name))
        print(f"Project structure created at {base_path}")
    except Exception as e:
        print(f"An error occurred: {e}")

def main():
    if len(sys.argv) != 3:
        print("Usage: python template.py <relative_path> <folder_name>")
        sys.exit(1)
    
    relative_path = sys.argv[1]
    folder_name = sys.argv[2]
    create_project_structure(relative_path, folder_name)

if __name__ == "__main__":
    main()