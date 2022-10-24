//File : main.gsp
uses java.util.*
uses java.io.*

//const that holds instructions
var bnfGrammar : String = "\n--------------------------------------------------------------------------------------\nBNF Grammar\n--------------------------------------------------------------------------------------\n       program -> ENTER <assignments> EXIT\n <assignments> -> <assignment> <assignments>\n                | <assignment>\n  <assignment> -> <bname> = <instruction> ;\n       <bname> -> Button <button_name>\n <button_name> -> A | B | C | D \n <instruction> -> FORWARD | BACKWARD | LEFT | RIGHT | SLEFT | SRIGHT\n------------------------------------------------------------------------------\nExample:\nENTER Button D = FORWARD; Button A = BACKWARD; Button C = LEFT; Button B = RIGHT; EXIT\n--------------------------------------------------------------------------------------"

//scanner for input
var sc : Scanner = new Scanner(System.in)
var prompt : String = "Input: "
var input : String = null

//All other classes, functions

/*
  The Language Recognizer Class nickname LangReco
  is a class that will take in a input String and check
  if it belongs to the meta-language
  should it not belong it'll report the errors it finds
  and prevent other methods from being called externally

  should the input string be vaid it'll provide a output string list
 */
class LangReco{
  //data members
  var _copy : String
  var _input : List<String>
  var _errors : List<String> = new ArrayList<String>()
  var isValid : boolean = false
  var _patternRoute : int = 0

  var _usedA = false
  var _usedB = false
  var _usedC = false
  var _usedD = false


  //public construction
  construct (rawString : String){
    _copy = rawString
    _input = new ArrayList<String>(Arrays.asList(rawString.split(" ")))
  }

  //public
  function getStringList() : List<String> {
    var r : List<String> = new ArrayList<String>(Arrays.asList(_copy.split(" ")))
    return r
  }

  function recognize(){
    if(_input.size() < 6 ){
      _errors.add("Logic Error: insufficient amount of text to build a program")
    } else {
      //it's of a valid length
      while(_input.size() != 0){
        _checkToken(_input.get(0))
      }
    }

    if(!(_errors.isEmpty())){
      isValid = false
      for (i in _errors){
        System.out.print(i)
      }
    } else{
      isValid = true
    }
  }

  //private methods
  function _checkToken(lexeme : String){
    switch(_patternRoute){
      case 0:{
        //checking if "ENTER" is correct
        if(_isENTER(lexeme)){
          _patternRoute = 1
          _input.remove(0)
        } else {
          _endAnalysis()
        }
        break
      }

      case 1:{
        //checking if "Button" is correct
        if(_isButton(lexeme)){
          _patternRoute = 2
          _input.remove(0)
        } else {
          _endAnalysis()
        }
        break
      }

      case 2:{
        //checking if "A" "B" "C" "D" is correct
        if(_isABCD(lexeme)){
          //checking if the button name has been used before
          if(_hasBeenUsed(lexeme)){
            _endAnalysis()
          } else {
            _patternRoute = 3
            _input.remove(0)
            break
          }
        } else {
          _endAnalysis()
        }
        break
      }

      case 3:{
        //checking if "=" is correct
        if(_isEqualSign(lexeme)){
          _patternRoute = 4
          _input.remove(0)
        } else {
          _endAnalysis()
        }
        break
      }

      case 4:{
        //checking if the current lexeme contains a semicolon
        if(_hasSemicolon(lexeme)){
          //checking if the instruction is correct with the semicolon
          if(_isInstructionS(lexeme)){
            _patternRoute = 6
            _input.remove(0)
          } else {
            _endAnalysis()
          }
        } else {
          //checking if the instruction is correct without the semicolon
          if(_isInstruction(lexeme)){
            _patternRoute = 5
            _input.remove(0)
          } else{
            _endAnalysis()
          }
        }
        break
      }

      case 5:{
        //checking if the ; is correct
        if(_isSemicolon(lexeme)){
          _patternRoute = 6
          _input.remove(0)
        }else {
          _endAnalysis()
        }
        break
      }

      case 6:{
        //checking if this is the last token
        if(_input.size() == 1){
          //the last token should be EXIT
          if(_isEXIT(lexeme)){
            _input.remove(0)
          } else {
            _endAnalysis()
          }
        } else{
          _patternRoute = 1
        }
      }
      break
    }
  }

  //Helper functions
  function _isEXIT(lexeme : String): boolean{
    if(lexeme == "EXIT"){
      return true
    } else{
      _errors.add("Syntax Error: expected \"EXIT\", found \"" + lexeme + "\"")
      return false
    }
  }
  function _isSemicolon(lexeme : String): boolean{
    if(lexeme == ";"){
      return true
    } else {
      _errors.add("Syntax Error: expected \";\", found \"" + lexeme + "\"")
      return false
    }
  }
  function _isInstruction(lexeme : String):boolean{
    if(lexeme == "FORWARD" || lexeme == "BACKWARD" || lexeme == "LEFT" || lexeme == "RIGHT" || lexeme == "SLEFT" || lexeme == "SRIGHT"){
      return true
    } else {
      _errors.add("Syntax Error: expected valid instruciton,\nValid instructions are: \"FORWARD\" \"BACKWARD\" \"LEFT\" \"RIGHT\" \"SLEFT\" \"SRIGHT\"")
      return false
    }
  }
  function _isInstructionS(lexeme : String): boolean{
    if(lexeme == "FORWARD;" || lexeme == "BACKWARD;" || lexeme == "LEFT;" || lexeme == "RIGHT;" || lexeme == "SLEFT;" || lexeme == "SRIGHT;"){
      return true
    } else {
      _errors.add("Syntax Error: expected valid instruciton,\nValid instructions are: \"FORWARD\" \"BACKWARD\" \"LEFT\" \"RIGHT\" \"SLEFT\" \"SRIGHT\"")
      return false
    }
  }
  function _isEqualSign(lexeme : String): boolean{
    if(lexeme == "="){
      return true
    } else{
      _errors.add("Syntax Error: expected \"=\", found \"" + lexeme + "\"")
      return false
    }
  }
  function _isABCD(lexeme : String): boolean{
    if(lexeme == "A" || lexeme == "B" || lexeme == "C" || lexeme == "D"){
      return true
    } else {
      _errors.add("Syntax Error: expected valid Button name,\nValid button names are: \"A\" \"B\" \"C\" \"D\"")
      return false
    }
  }
  function _isButton(lexeme : String): boolean{
    if(lexeme == "Button"){
      return true
    } else {
      _errors.add("Syntax Error: expected \"Button\", found \"" + lexeme + "\" instead.")
      return false
    }
  }
  function _isENTER(lexeme : String): boolean{
    if(lexeme == "ENTER"){
      return true
    } else {
      _errors.add("Syntax Error: expected \"ENTER\", found \"" + lexeme + "\" instead.")
      return false
    }
  }

  function _hasSemicolon(lexeme : String):boolean{
    var temp : List<String> = new ArrayList<String>(Arrays.asList(lexeme.split("")))
    for( i in temp){
      if(i.equals(";")){
        return true
      }
    }
    return false
  }
  function _hasBeenUsed(lexeme : String):boolean{
    switch (lexeme){
      case "A":{
        if(_usedA){
          _errors.add("Logic Error: \"A\" has already been assigned a instruction")
          return true
        }else {
          _usedA = true
          return false
        }
      }
      case "B":{
        if(_usedB){
          _errors.add("Logic Error: \"B\" has already been assigned a instruction")
          return true
        }else {
          _usedB = true
          return false
        }
      }
      case "C":{
        if(_usedC){
          _errors.add("Logic Error: \"C\" has already been assigned a instruction")
          return true
        }else {
          _usedC = true
          return false
        }
      }
      case "D":{
        if(_usedD){
          _errors.add("Logic Error: \"D\" has already been assigned a instruction")
          return true
        }else {
          _usedD = true
          return false
        }
      }
    }
    return false
  }
  function _endAnalysis(){
    _input.clear()
  }
}
class RobotFile{
  var _sentence : List<String>
  var _filename : String = "C:\\Users\\mikeg\\Desktop\\IZEBOT.BSP"

  construct (validInput : List<String>){
      _sentence = validInput
  }

  function generate(){
    //creating file object to track the file we'll be manipulating
    var output : File = new File(_filename)
    output.delete()
    output = new File(_filename)

    //creating the output file
    print("Attempting to generate BSP file")
    if (!(output.createNewFile())){
      print("Unable to create file")
      return
    }
    //file has been created
    _writeToFile()
  }

  function _writeToFile(){
    //required stuff
    var headerBlock : String = "'{$STAMP BS2p}\n'{$STAMP 2.5}\nKEY        VAR   Byte\nMAIN:      DO\n           SERIN 3,2063,250,Timeout,[KEY]\n"
    var footerOne : String = "\n           LOOP\nTimeout:   GOSUB Motor_OFF\n           GOTO Main\n'+++++ Movement Procedure ++++++++++++++++++++++++++++++\n"
    var subForward : String = "\nForward:   HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN\n"
    var subBackward : String = "\nBackward:  HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN\n"
    var subTurnLeft : String = "\nTurnLeft:  HIGH 13 : LOW 12 : LOW  15 : LOW 14 : RETURN\n"
    var subTurnRight : String = "\nTurnRight: LOW  13 : LOW 12 : HIGH 15 : LOW 14 : RETURN\n"
    var subSpinLeft : String = "\nSpinLeft:  HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN\n"
    var subSpingRight : String = "\nSpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN\n"
    var footerTwo : String = "\nMotor_OFF: LOW  13 : LOW 12 : LOW  15 : LOW 14 : RETURN\n'+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

    //PBASIC conversion
    //var bodyBlock : String = //function
    //var subRoutineBlock : String = //function

    //creating a writer to write to file
    var w : FileWriter = new FileWriter(_filename)
    print("Converting meta-language to PBASIC")
    w.write(headerBlock)
    //w.write(bodyBlock)
    w.write(footerOne)
    //w.write(subRoutineBlock)
    w.write(footerTwo)
    w.close()
    print("Successfully created BSP file")
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
        System.out.print("Generating File\n")
        var o : RobotFile = new RobotFile(lr.getStringList())
        o.generate()
      }
      input = sc.nextLine()
      //clear screen
    }
  }
}
//entry point for the whole program
program()