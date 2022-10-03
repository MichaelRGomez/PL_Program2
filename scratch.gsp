uses java.util.*

//Main
//const that holds instructions
var bnfGrammar : String = "working bnf grammar\n------------------------------------------------------------------------------\nBNF Grammar\n------------------------------------------------------------------------------\n       program -> ENTER <assignments> END\n <assignments> -> <assignment> ; <assignment>\n                | <assignment>\n  <assignment> -> <button> = <instruction>\n      <button> -> A | B | C | D\n <instruction> -> forward | backward | left | right | spinleft | spinright\n------------------------------------------------------------------------------\nExample:\n ENTER A = backward ; D = forward END\n------------------------------------------------------------------------------"
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
    if(input == "HALT"){ break }
  }
}

function main(){
    program()
}

//final function call
main()
