# ToyC编译器 - RISC-V代码生成器

[![GitHub stars](https://img.shields.io/github/stars/username/ToyC_Compiler.svg?style=social)](https://github.com/username/ToyC_Compiler)
[![GitHub license](https://img.shields.io/github/license/username/ToyC_Compiler.svg)](https://github.com/username/ToyC_Compiler/blob/main/LICENSE)

这是一个完整的ToyC编程语言编译器，支持将ToyC源代码编译为RISC-V 32位汇编代码。该项目旨在提供一个教育性的编译器实现，展示现代编译器的基本原理和技术。

## 项目结构

```
toyc_compiler/
├── lib/                     # 核心库模块
│   ├── ast.ml              # 抽象语法树定义
│   ├── ast.mli             # AST模块接口
│   ├── lexer.mll           # 词法分析器
│   ├── parser.mly          # 语法分析器  
│   ├── semantic.ml         # 语义分析器
│   ├── semantic.mli        # 语义分析模块接口
│   ├── symbol.ml           # 符号表管理
│   ├── symbol.mli          # 符号表模块接口
│   ├── riscv.ml            # RISC-V指令定义
│   ├── riscv.mli           # RISC-V模块接口
│   ├── codegen.ml          # 代码生成器
│   ├── codegen.mli         # 代码生成模块接口
│   ├── toyc_compiler.ml    # 主库接口
│   └── toyc_compiler.mli   # 主库接口定义
├── bin/                    # 可执行程序
│   ├── dune                # Dune构建配置
│   └── main.ml             # 编译器主程序
├── test/                   # 测试用例
│   ├── dune                # Dune测试配置
│   ├── test_toyc_compiler.ml  # 语义分析测试
│   └── test_codegen.ml     # 代码生成测试
├── test_30/                # 30个测试用例
│   ├── 01_minimal.tc       # 最小程序示例
│   ├── 02_assignment.tc    # 赋值语句测试
│   └── ...                 # 其他测试用例
├── 任务解析/               # 项目文档
│   └── ToyC文法.md         # ToyC语言文法定义
├── README.md              # 项目文档
├── CODEGEN_README.md      # 代码生成器说明
├── dune                   # 项目构建配置
├── dune-project           # Dune项目配置
└── toyc_compiler.opam     # OPAM包配置
```

## 功能特性

### 支持的语言特性

- **数据类型**：int、void
- **变量**：声明、赋值、作用域
- **表达式**：算术运算（+、-、*、/）、比较运算（<、>、<=、>=、==、!=）
- **控制流**：if/else条件语句、while循环
- **函数**：定义、调用、递归、参数传递
- **语句**：break、continue、return

### 编译流程

1. **词法分析**：将源代码转换为token流
2. **语法分析**：构建抽象语法树（AST）
3. **语义分析**：类型检查、作用域分析、符号表管理
4. **代码生成**：将AST翻译为RISC-V汇编代码

## 快速开始

### 环境要求

- OCaml 4.12.0 或更高版本
- Dune 3.0 或更高版本
- Menhir 20210419 或更高版本（用于语法分析）

### 安装依赖

```bash
# 使用OPAM安装依赖
opam install dune menhir
```

### 编译项目

```bash
# 构建项目
dune build

# 运行测试
dune test
```

### 编译ToyC程序

编译器使用标准输入输出接口，支持以下使用方式：

#### 基本编译

```bash
# 从标准输入读取源码，输出汇编到标准输出
./_build/default/bin/main.exe < input.tc > output.s

# 或者使用管道
echo 'int main() { return 42; }' | ./_build/default/bin/main.exe > output.s
```

#### 开启优化编译

```bash
# 使用 -opt 参数开启优化
./_build/default/bin/main.exe -opt < input.tc > output.s
```

#### 测试编译示例

```bash
# 编译最小程序示例
./_build/default/bin/main.exe < test_30/01_minimal.tc > minimal_output.s

# 编译函数调用示例
./_build/default/bin/main.exe < test_30/05_function_call.tc > function_output.s

# 编译递归示例
./_build/default/bin/main.exe < test_30/09_recursion.tc > recursion_output.s
```

### 本地测试方法

#### 1. 测试单个文件

```bash
# 编译test_30目录中的测试用例
./_build/default/bin/main.exe < test_30/01_minimal.tc > test_output.s

# 检查生成的汇编代码
cat test_output.s
```

#### 2. 批量测试所有用例

创建测试脚本：

```bash
#!/bin/bash
echo "=== 测试所有 test_30 用例 ==="

# 构建编译器
dune build bin/main.exe

failed_tests=""
passed_tests=""

# 测试所有 .tc 文件
for tc_file in test_30/*.tc; do
    base_name=$(basename "$tc_file" .tc)
    output_file="test_30/${base_name}_output.s"
    
    echo "测试: $base_name"
    ./_build/default/bin/main.exe < "$tc_file" > "$output_file" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "✅ $base_name 编译成功"
        passed_tests="$passed_tests $base_name"
    else
        echo "❌ $base_name 编译失败"
        failed_tests="$failed_tests $base_name"
    fi
done

echo ""
echo "=== 测试结果 ==="
echo "通过的测试:$passed_tests"
if [ -n "$failed_tests" ]; then
    echo "失败的测试:$failed_tests"
else
    echo "所有测试都通过了！"
fi
```

保存为 `test_all.sh`，然后运行：

```bash
chmod +x test_all.sh
./test_all.sh
```

#### 3. 验证复杂语法

```bash
# 测试复杂语法文件（包含各种注释和语法结构）
./_build/default/bin/main.exe < test_30/16_complex_syntax.tc > complex_output.s

# 检查是否有语法错误
echo $?  # 0表示成功，非0表示失败
```

#### 4. 调试模式

编译器会在标准错误输出调试信息：

```bash
# 查看详细的编译过程信息
./_build/default/bin/main.exe < test_30/05_function_call.tc > output.s
# 会显示：
# 语法分析完成，共解析了 2 个函数
# 语义分析完成  
# 代码生成完成
```

#### 5. 错误测试

```bash
# 测试语法错误（故意的语法错误）
echo 'int main() { return ; }' | ./_build/default/bin/main.exe
# 会显示语法分析错误信息

# 测试语义错误
echo 'int main() { int x; return x + unknown_var; }' | ./_build/default/bin/main.exe
# 会显示语义错误信息
```

### 运行单元测试

```bash
# 运行语义分析测试（如果ounit2可用）
dune test

# 如果测试依赖不可用，直接测试编译功能
dune build && echo "构建成功，可以进行功能测试"
```

## ToyC语言示例

### 简单程序

```c
int main() {
    int x = 5;
    int y = 10;
    int sum = x + y;
    return sum;
}
```

### 带控制流的程序

```c
int factorial(int n) {
    if (n <= 1) {
        return 1;
    } else {
        return n * factorial(n - 1);
    }
}

int main() {
    int x = 5;
    int result = factorial(x);
    return result;
}
```

### 循环程序

```c
int sum_to_n(int n) {
    int sum = 0;
    int i = 1;
    while (i <= n) {
        sum = sum + i;
        i = i + 1;
    }
    return sum;
}

int main() {
    return sum_to_n(10);
}
```

## 生成的汇编代码特性

### RISC-V指令集

- 使用RISC-V RV32I基础指令集
- 标准调用约定：`x10-x17`用于参数和返回值
- 栈指针：`x2 (sp)`，帧指针：`x8 (fp)`
- 返回地址：`x1 (ra)`

### 内存管理

- 栈式内存分配
- 局部变量存储在栈帧中
- 正确的函数序言和尾声代码

### 控制流

- 条件分支使用比较和跳转指令
- 循环使用标签和条件跳转
- 函数调用使用`jal`指令

## 项目架构

### 核心模块

1. **AST (ast.ml)**：定义语言的抽象语法树结构
2. **Lexer (lexer.mll)**：词法分析，识别token
3. **Parser (parser.mly)**：语法分析，构建AST
4. **Semantic (semantic.ml)**：语义分析和类型检查
5. **Symbol (symbol.ml)**：符号表管理和作用域处理
6. **RISCV (riscv.ml)**：RISC-V指令定义和输出
7. **Codegen (codegen.ml)**：AST到汇编代码的翻译

### 设计特点

- **模块化设计**：清晰的模块分离，便于维护和扩展
- **类型安全**：完整的类型检查和错误报告
- **标准兼容**：生成的汇编代码符合RISC-V标准
- **可扩展性**：易于添加新的语言特性和优化

## 测试验证

项目包含了完整的测试套件：

- **语义分析测试**：31个测试用例，覆盖各种语言特性和错误情况
- **代码生成测试**：验证生成汇编代码的正确性
- **集成测试**：端到端的编译流程测试

### 运行测试示例

```bash
# 运行所有测试
dune test

# 运行代码生成测试
dune exec test/test_codegen.exe

# 测试复杂程序编译
dune exec bin/main.exe -- complex_test.tc -o complex_output.s
```

## 技术细节

### 寄存器分配

- 临时寄存器：`x5-x7, x28-x31`
- 函数参数：`x10-x17`
- 返回值：`x10`
- 调用保存：正确保存和恢复寄存器

### 标签管理

- 自动生成唯一标签
- 支持嵌套控制结构
- 正确处理break/continue

### 错误处理

- 详细的错误信息和位置报告
- 完整的语义检查
- 友好的用户界面

## 贡献指南

我们欢迎对本项目的贡献！如果您有兴趣参与，请遵循以下步骤：

1. **Fork 仓库**：在GitHub上fork本项目到您自己的账户
2. **创建分支**：为您的功能或修复创建一个新的分支
3. **提交更改**：确保您的代码符合项目的代码风格和质量要求
4. **运行测试**：确保所有测试都通过
5. **提交PR**：创建一个Pull Request，描述您的更改和动机

### 开发规范

- 代码风格：遵循OCaml的标准代码风格
- 提交消息：使用清晰、简洁的提交消息
- 测试：为新功能添加适当的测试用例
- 文档：更新相关文档以反映您的更改

## 扩展方向

该编译器设计为易于扩展，可以添加以下特性：

- **更多数据类型**：float、array、struct、指针等
- **更多语言特性**：for循环、switch语句、全局变量等
- **优化**：常量折叠、死代码消除、寄存器分配优化等
- **更多目标架构**：x86-64、ARM等
- **工具链集成**：与汇编器和链接器的集成

## 教育价值

本项目非常适合以下教育目的：

- **编译器原理学习**：了解现代编译器的基本原理和技术
- **OCaml编程实践**：学习OCaml语言的高级特性和编程风格
- **RISC-V架构理解**：通过生成RISC-V汇编代码，深入理解RISC-V架构
- **软件工程实践**：学习模块化设计、测试驱动开发等软件工程实践

## 许可证

本项目采用MIT许可证，详见[LICENSE](LICENSE)文件。

## 联系方式

如有任何问题或建议，请通过以下方式联系我们：

- **GitHub Issues**：在项目仓库中创建Issue
- **Email**：[your-email@example.com](mailto:your-email@example.com)

## 鸣谢

感谢所有为该项目做出贡献的开发者和教育工作者！

---

**ToyC编译器** - 一个用于教育目的的现代编译器实现
