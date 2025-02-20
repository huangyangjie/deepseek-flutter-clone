import sys
import json
from openai import OpenAI

prompt = """
你是一个专业的多语言翻译助手，精通编程规范和小驼峰命名法。请按照以下步骤处理我的输入：

1. 接收用户提供的名词或短语
2. 生成符合编程规范的小驼峰式变量名（采用lowerCamelCase格式）
3. 提供准确的英语翻译（首字母大写）
4. 提供与原文一致的中文翻译
5. 提供标准阿拉伯语翻译（使用Unicode字符）
6. 结果按指定JSON格式输出
7. 不要改变用户输入的内容

输出要求：
- JSON键名固定为：variableName, english, chinese, arabic
- 禁止添加额外说明或格式化字符
- 阿拉伯语确保从右向左正确显示

示例：
输入："用户年龄"
输出：
{
"variableName": "userAge",
"english": "User Age",
"chinese": "用户年龄", 
"arabic": "عمر المستخدم"
}

现在请处理这个输入：
"""

client = OpenAI(
    api_key="", 
    base_url="https://dashscope.aliyuncs.com/compatible-mode/v1",
)

languages = {
    "english": "en_US",
    "chinese": "zh_CN",
    "arabic": "ar_AR"
}

local_path = "lib/configs/localization/"

def ask_ai(message: str) -> dict:
    completion = client.chat.completions.create(
        model="deepseek-v3", 
        messages=[
        {'role': 'system', 'content': prompt},
        {'role': 'user', 'content': message}
    ])

    res = completion.choices[0].message.content
    print(res)
    return json.loads(res) if res else {}

#在文件的 ## AiTranslator 下插入
def update_file(file_path, content):
    with open(file_path, 'r') as file:
        data = file.readlines()
    with open(file_path, 'w') as file:
        for line in data:
            file.write(line)
            if "##AiTranslator" in line:
                file.write(content)

def main():
    if len(sys.argv) < 2:
        print("Please provide an argument")
        sys.exit(1)
    
    message = sys.argv[1]
    res = ask_ai(message)
    # l10n_enum.dart
    update_file(local_path + "l10n_enum.dart", f"  static const String {res['variableName']} = '{res['variableName'].title()}';\n")
    # language
    for key, value in languages.items():
        update_file(local_path + f"{value}/{value.lower()}_translation.dart", f"  L10nEnum.{res['variableName']}: '{res[key]}',\n")

if __name__ == "__main__":
    main()