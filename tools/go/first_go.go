/* 包声明 */
package main
/* 包引入 */
import "fmt"
/* 函数 */
func main() {
   /* 变量声明 var var_name var_type 1.9之后会根据赋值自动识别类型 */
   var hello string = "Hello"
   var kamma = ", "
   world := "World!"
   /* 支持多个变量同时声明 如 var var1,var2,var3 = v1,v2,v3 */

   /* 常量用const关键字来声明 */
   const auth string = "alex"

   /* 结构体定义需要用到type关键字 */
   type myfamily struct {
        vatter string
        mutter string
        mine   string
   }

   /* 数组的声明 数据的长度是固定的，如果不定长就要用切片slice */

   var myarr [9] int
   a := [3][4]int{{0, 1, 2, 3}, {4, 5, 6, 7}, {8, 9, 10, 11}}

   /* 切片定义, make 第二个参数为切片初始化长度，第三个参数为切片容量 */
   var myslice [] int
   slice := make([]int , 5, 10)

   fmt.Println(hello,kamma,world)
}
/* 标示符如果是大写开头的，则包外可见，否则包外不可见 */
