uses java.util.*

//Main
//const that holds instructions
var bnfGrammar : String = "working bnf grammar\n--------------------------------------------------------------------------------------\nBNF Grammar\n--------------------------------------------------------------------------------------\n       program -> ENTER <assignments> EXIT\n <assignments> -> <assignment> <assignments>\n                | <assignment>\n  <assignment> -> <bname> = <instruction> ;\n       <bname> -> Button <button_name>\n <button_name> -> A | B | C | D \n <instruction> -> FORWARD | BACKWARD | LEFT | RIGHT | SLEFT | SRIGHT\n------------------------------------------------------------------------------\nExample:\nENTER Button D = FORWARD; Button A = BACKWARD; Button C = LEFT; Button B = RIGHT; EXIT\n--------------------------------------------------------------------------------------"
var sc : Scanner = new Scanner(System.in) //scanner for input
var prompt : String = "Input: "
var input : String = null

//program loop
function program(){
  while(true){
    //printing instructions and prompting for input
    print(bnfGrammar)
    System.out.print(prompt)
    input = sc.nextLine()

    //checking input
    if(input == "QUIT"){ break }
  }
}

function main(){
    program()
}

//final function call
main()
