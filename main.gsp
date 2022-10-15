//File : main.gsp
uses java.util.*

//const that holds instructions
var bnfGrammar : String = "\nworking bnf grammar\n--------------------------------------------------------------------------------------\nBNF Grammar\n--------------------------------------------------------------------------------------\n       program -> ENTER <assignments> EXIT\n <assignments> -> <assignment> <assignments>\n                | <assignment>\n  <assignment> -> <bname> = <instruction> ;\n       <bname> -> Button <button_name>\n <button_name> -> A | B | C | D \n <instruction> -> FORWARD | BACKWARD | LEFT | RIGHT | SLEFT | SRIGHT\n------------------------------------------------------------------------------\nExample:\nENTER Button D = FORWARD; Button A = BACKWARD; Button C = LEFT; Button B = RIGHT; EXIT\n--------------------------------------------------------------------------------------"

//scanner for input
var sc : Scanner = new Scanner(System.in)
var prompt : String = "Input: "
var input : String = null

//All other classes, functions,

//The LangReco class (language recognizer) takes and input string and checks
//If the input string is off the designated language
public class LangReco{
  var _input : List<String>
  var _valid : boolean = false
  var _errors : List<String> = new ArrayList<String>()
  var _patInd : int = 0
  var _semicolon : boolean = false

  //constructor
  //the construct method splits the input string and turns it into a list
  //of string delimeted by spaces
  construct(input_string : String){
    _input = new ArrayList<String>(Arrays.asList(input_string.split(" ")))
  }

  //isValid() returns true if the string is of the language'
  //otherise it'll return false
  property get isValid() : boolean{
    return _valid
  }

  //recognize() method checks the whole list if it's of the string
  function recognize(){
    //Slowly emptying the _input list
    while(!_input.isEmpty()){

      checkToken(_input.get(0))
      _input.remove(0)
    }

    //Check if there was errors
    if(!(_errors.isEmpty())){
      _valid = false
      print("\nErrors:\n")
      for(i in _errors){
        print(i)
      }
    } else {
      _valid = true
    }
  }

  //This function checks a given token
  //using _patInd it knows what lexeme to compare the token with
  //I'll report any errors and append them to the errors list()

  function checkToken( token : String){
    switch(_patInd) {
      //case 0: checks for "ENTER"
      case 0: {
        if (!(token == "ENTER")) {
          _errors.add("Syntax error at \"" + token + "\" expected \"ENTER\" instead")
        }
        _patInd = 1
        break
      }

      //case 1: checks for "Button"
      case 1: {
        if (!(token == "Button")) {
          _errors.add("Syntax error at \"" + token + "\" expected \"Button\" instead")
        }
        _patInd = 2
        break
      }

      //case 2: checks for "A" , "B" , "C" , "D"
      case 2: {
        if (!(token == "A" || token == "B" || token == "C" || token == "D")) {
          _errors.add("Syntax error at \"" + token + "\" valid Button names are \"A\" or \"B\" or \"C\" or \"D\"")
        }
        _patInd = 3
        break
      }

      //case 3: checks of the assignment sign "="
      case 3: {
        if (!(token == "=")) {
          _errors.add("Syntax error at \"" + token + "\" expected \"=\" instead")
        }
        _patInd = 4
        break
      }

      //case 4: checks which instruction was provided
      //instructions: "FORWARD" , "BACKWARD" , "LEFT" , "RIGHT" , "SLEFT" , "SRIGHT"
      case 4:
        //checking if the semi-colon is appended at the back of the token
        var temp = new ArrayList<String>(Arrays.asList(token.split("")))
        for (i in temp) {
          if (i.equals(";")) {
            _semicolon = true
          }
        }

        if (_semicolon) {
          if (!(token == "FORWARD;" || token == "BACKWARD;" || token == "LEFT;" || token == "RIGHT;" || token == "SLEFT;" || token == "SRIGHT;")) {
            _errors.add("Syntax error at \"" + token + "\" valid instructions are:\n \"FORWARD;\" OR \"BACKWARD;\" OR \"RIGHT;\" OR \"LEFT;\" OR \"SLEFT;\" OR \"SRIGHT;\"")
          }
        } else {
          if (!(token == "FORWARD" || token == "BACKWARD" || token == "LEFT" || token == "RIGHT" || token == "SLEFT" || token == "SRIGHT")) {
            _errors.add("Syntax error at \"" + token + "\" valid instructions are:\n \"FORWARD\" OR \"BACKWARD\" OR \"RIGHT\" OR \"LEFT\" OR \"SLEFT\" OR \"SRIGHT\"")
          }
        }
        _patInd = 5
        break

      //case 5: checks for a semi-colon or EXIT
      case 5: {
        //last case left of language recognizer
        break
      }
    }
  }
}

//main function
function program(){
  while(true){
    //printing instructions and prompting for input
    print(bnfGrammar)
    System.out.print(prompt)
    input = sc.nextLine()

    //checking input
    if(input == "QUIT"){ break }
    else {
      var lr : LangReco = new LangReco(input)
      lr.recognize()
      if(lr.isValid){
        //the other functions
      }
      input = sc.nextLine()
      //clear screen
    }
  }
}
//entry point for the whole program
program()