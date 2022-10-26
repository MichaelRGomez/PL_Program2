//File : main.gsp
uses java.util.*
uses java.io.*

//const that holds instructions
var bnfGrammar : String = "\n--------------------------------------------------------------------------------------\nBNF Grammar\n--------------------------------------------------------------------------------------\n       program -> ENTER <assignments> EXIT\n <assignments> -> <assignment> <assignments>\n                | <assignment>\n  <assignment> -> <bname> = <instruction> ;\n       <bname> -> Button <button_name>\n <button_name> -> A | B | C | D \n <instruction> -> FORWARD | BACKWARD | LEFT | RIGHT | SLEFT | SRIGHT\n------------------------------------------------------------------------------\nExample:\nENTER Button D = FORWARD; Button A = BACKWARD; Button C = LEFT; Button B = RIGHT; EXIT\n--------------------------------------------------------------------------------------"

//scanner for input
var sc : Scanner = new Scanner(System.in)
var prompt : String = "Input: "
var input : String = null
var dump : String = null

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
  var _returnString : String = ""
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

  function metaLangCode() : String {
    return _returnString
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
            _returnString = _returnString + ","
            _returnString = _returnString + lexeme
            _returnString = _returnString + ","
            _returnString = _returnString + lexeme.toLowerCase()
            _returnString = _returnString + ","
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
            _returnString= _returnString + _correctInstruction(lexeme)
            _patternRoute = 6
            _input.remove(0)
            _isIncomplete()

          } else {
            _endAnalysis()
          }
        } else {
          //checking if the instruction is correct without the semicolon
          if(_isInstruction(lexeme)){
            _returnString= _returnString + _correctInstruction(lexeme)
            _patternRoute = 5
            _input.remove(0)
            _isIncomplete()
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
          _isIncomplete()
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

  function _isIncomplete(){
    if(_input.size() == 0){
      _errors.add("Syntax Error: incompleted instruction")
      _endAnalysis()
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

  function _correctInstruction(badInstruction : String) : String{
    switch (badInstruction){
      case "FORWARD": return "Forward"
      case "BACKWARD": return "Backward"
      case "LEFT": return "TurnLeft"
      case "RIGHT": return "TurnRight"
      case "SRIGHT": return "SpinLeft"
      case "SLEFT": return "SpinRight"
      case "FORWARD;": return "Forward"
      case "BACKWARD;": return "Backward"
      case "LEFT;": return "TurnLeft"
      case "RIGHT;": return "TurnRight"
      case "SRIGHT;": return "SpinLeft"
      case "SLEFT;": return "SpinRight"
    }
    return ""
  }
}
class RobotFile{
  var _code : List<String>
  var _filename : String = "C:\\Users\\mikeg\\Desktop\\IZEBOT.BSP"

  construct (metaCode : String){
    _code = new ArrayList<String>(Arrays.asList(metaCode.split(",")))
    _code.remove(0)
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
    if(!(_code.isEmpty())){

      //required stuff
      var headerBlock : String = "'{$STAMP BS2p}\n'{$PBASIC 2.5}\nKEY        VAR   Byte\nMAIN:      DO\n           SERIN 3,2063,250,Timeout,[KEY]\n"
      var footerOne : String = "\n           LOOP\nTimeout:   GOSUB Motor_OFF\n           GOTO Main\n'+++++ Movement Procedure ++++++++++++++++++++++++++++++\n"
      var footerTwo : String = "\nMotor_OFF: LOW  13 : LOW 12 : LOW  15 : LOW 14 : RETURN\n'+++++++++++++++++++++++++++++++++++++++++++++++++++++++\n"

      //creating a writer to write to file
      var w : FileWriter = new FileWriter(_filename)
      print("Converting meta-language to PBASIC")
      w.write(headerBlock)
      _genBody(w)
      w.write(footerOne)
      _genSub(w)
      w.write(footerTwo)
      w.close()
      print("Successfully created BSP file")
    }
  }

  function _genBody( w : FileWriter){
    var limit : int = ((_code.size()) / 3)
    var counter : int = 0
    var x : int = 0
    var s : String = ""

    while(!( counter == limit)){
      s = s + "\nIF KEY = \""
      s = s + _code.get(x)
      s = s + "\" OR KEY = \""
      s = s + _code.get(x+1)
      s = s + "\" THEN GOSUB "
      s = s + _code.get(x+2)
      s = s + "\n"
      w.write(s)
      s = ""
      x = x + 3
      counter++
    }
  }
  function _genSub(w : FileWriter){
    var limit : int = ((_code.size()) / 3)
    var counter : int = 0
    var x : int = 0

    while(counter != limit){
      switch(_code.get(x+2)){
        case "Forward": {
          w.write("\nForward: HIGH 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN\n")
          break
        }
        case "Backward": {
          w.write("\nBackward: HIGH 12 : LOW 13 : HIGH 14 : LOW 15 : RETURN\n")
          break
        }
        case "TurnLeft": {
          w.write("\nTurnLeft: HIGH 13 : LOW 12 : LOW 15 : LOW 14 : RETURN\n")
          break
        }
        case "TurnRight": {
          w.write("\nTurnRight: LOW 13 : LOW 12 : HIGH 15 : LOW 14 : RETURN\n")
          break
        }
        case "SpinLeft": {
          w.write("\nSpinLeft: HIGH 13 : LOW 12 : HIGH 14 : LOW 15 : RETURN\n")
          break
        }
        case "SpingRight": {
          w.write("\nSpinRight: HIGH 12 : LOW 13 : HIGH 15 : LOW 14 : RETURN\n")
          break
        }
      }
      x = x + 3
      counter++
    }
  }
}
class Deri{
  var _list : List<String>
  var _Plist : List<String>
  var _mutliAssign : boolean = false
  var _processing : boolean = true
  var _masterIndex : int = -1

  construct (sentence : String){
    _list = new ArrayList<String>(Arrays.asList(sentence.split(" ")))
    _Plist = new ArrayList<String>()
  }

  function derivate(){
    _cleanList()
    _masterIndex = _list.size() - 1

    _AprintList()
    while (_processing){
      _reverseDerivate(_masterIndex)
    }
    _printD()
  }

  //helper functions
  function _reverseDerivate(m : int){
    if(_list.size() == 3){
      _processing = false
      return
    }

    switch(_list.get(m)){
      case "EXIT":{
        _list.set(m-2, "<instruction>")
        _masterIndex = m - 3
        break
      }
      case "=":{
        _list.set(m-1, "<button_name>")
        _masterIndex = m -2
        break
      }
      case "Button":{
        _list.set(m, "<bname>")
        _list.remove(m+1)
        break
      }
      case "<bname>":{
        _list.set(m, "<assignment>")
        _list.remove(m+1)
        _list.remove(m+1)
        _list.remove(m+1)
        break
      }
      case "<assignment>":{
        if(_list.get(m+1) == "<assignments>"){
          _list.remove(m)
        }
        else{
          _list.set(m, "<assignments>")
        }
        break
      }
      case "<assignments>":{
        if(_list.get(m-1) == "ENTER"){
          _list.remove(m)
          _processing = false
        } else {
          _list.set(m-2, "<instruction>")
          _masterIndex = m - 3
        }
        break
      }
    }
    _AprintList()
}

  function _AprintList(){
    var holder : String = ""
    for ( i in _list){
      holder = holder + i + " "
    }
    _Plist.add(holder)
  }

  function _printD(){
    var copy : List<String> = new ArrayList<String>()
    for (i in _Plist){
      copy.add(0, i)
    }

    for(j in copy){
      System.out.print(j + "\n")
    }
  }

  function _cleanList(){
    var i : int = 0

    while (i != _list.size()){
      if(_checkForSemicolon(_list.get(i),i)){
        i = i + 2
      } else {
        i++
      }
    }
  }

  function _checkForSemicolon( lexeme : String, i : int) : boolean{
    var temp : List<String> = new ArrayList<String>(Arrays.asList(lexeme.split("")))
    var mainL : String = ""
    var subL : String = ""

    if(temp.size() == 1){
      return true
    } else {
      for (x in temp) {
        if (x.equals(";")) {
          mainL = lexeme.substring(0, lexeme.length() - 1)
          subL = ";"

          _list.set(i, mainL)
          _list.add(i + 1, subL)
          return true
        }
      }
      return false
    }
  }
}

// v_v helper function for PTree
class prefix{
  var _actualPrefix : List<String>
  var _layerCount : int
  var space : String = "`-> "

  construct (){
    _actualPrefix = new ArrayList<String>()
    _layerCount = 0
  }

  function addLayer( c : String){
    var l : int = c.length()
    var x : int = 0
    var temp : String = ""
    while (x != l){
      temp = temp + " "
      x++
    }
    _actualPrefix.add(temp)
    _layerCount++
  }

  function addLayerBranch(c : String){
    var l : int = c.length()
    var x : int = 1
    var temp : String = ""
    while (x != l){
      temp = temp + " "
      x++
    }
    _actualPrefix.add(temp + "|")
    _layerCount++
  }

  function removeLayer(){
    _actualPrefix.remove(_actualPrefix.size() - 1)
  }

  function reset(){
    _actualPrefix.clear()
    _layerCount = 0
  }

  function getPrefix() : String{
    var returnString : String = ""
    var x : int = 0
    var y : int = _actualPrefix.size()

    while (x != y){
      returnString = returnString + _actualPrefix.get(x)
      x++
    }
    return returnString + "`-> "
  }
}
class PTree{
  var _list : List<String>
  var _Plist : List<String>
  var _pre : prefix
  var semiColons : int

  construct (sentence : String){
    _list = new ArrayList<String>(Arrays.asList(sentence.split(" ")))
    _Plist = new ArrayList<String>()
    _pre = new prefix()
  }

  function drawTree(){
    _cleanList()
    semiColons = _countSemiColons()

    _list.add(0, "program")
    _buildTree(_list.get(0))

    for( i in _Plist){
      System.out.println(i)
    }
  }

  function _buildTree(s : String){
    switch(s){
      case "program":{
        _Plist.add(_list.get(0))
        _pre.addLayerBranch(_list.get(0))
        _list.remove(0)
        _buildTree(_list.get(0))
        break
      }
      case "ENTER":{
        _Plist.add(_pre.getPrefix() + _list.get(0))
        _list.remove(0)
        _list.add(0, "<assignments>")
        _buildTree(_list.get(0))
        break
      }
      case "<assignments>":{
        if (semiColons != 1){
          _pmAssignment(_list.get(0))
        } else {
          _psAssignment(_list.get(0))
        }
        _buildTree(_list.get(0))
        break
      }
      case "EXIT":{
        _pre.reset()
        _pre.addLayer("program")
        _Plist.add(_pre.getPrefix() + _list.get(0))
        _list.remove(0)
      }
      break
    }
  }
  function _pmAssignment(s : String){
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.addLayerBranch("<assignments>" + _pre.space)
    _list.remove(0)

    _list.add(0, "<assignment>")
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.addLayerBranch(_list.get(0) + _pre.space)
    _list.remove(0)

    _printAssignment()

    _list.add(0,"<assignments>")
  }
  function _psAssignment(s : String){
    _pre.removeLayer()
    _pre.addLayer("<assignments>" + _pre.space)
    _Plist.add(_pre.getPrefix() + "<assignment>")
    _pre.addLayer("<assignment>" + _pre.space)
    _list.remove(0)

    _list.add(0, "<assignment>")
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.addLayerBranch(_list.get(0) + _pre.space)
    _list.remove(0)

    _printAssignment()
  }
  function _printAssignment(){
    _list.add(0, "<bname>")
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.addLayerBranch(_list.get(0) + _pre.space)
    _list.remove(0)

    _Plist.add(_pre.getPrefix() + _list.get(0))
    _list.remove(0)

    _pre.removeLayer()
    _pre.addLayer("<bname>" + _pre.space)

    _list.add(0, "<button_name>")
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.removeLayer()
    _pre.addLayer("<bname>" + _pre.space)
    _pre.addLayer(_list.get(0) + _pre.space)
    _list.remove(0)

    _Plist.add(_pre.getPrefix() + _list.get(0))
    _list.remove(0)

    _pre.removeLayer()
    _pre.removeLayer()

    _Plist.add(_pre.getPrefix() + _list.get(0))
    _list.remove(0)

    _list.add(0, "<instruction>")
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _pre.addLayer(_list.get(0) + _pre.space)
    _list.remove(0)

    _Plist.add(_pre.getPrefix() + _list.get(0))
    _list.remove(0)

    _pre.removeLayer()

    _pre.removeLayer()
    _pre.addLayer("<assignments" + _pre.space)
    _Plist.add(_pre.getPrefix() + _list.get(0))
    _list.remove(0)
    semiColons--
    _pre.removeLayer()
    _pre.removeLayer()
    _pre.addLayer("<assignments" + _pre.space)
  }

  function _cleanList(){
    var i : int = 0
    while (i != _list.size()){
      if(_checkForSemicolon(_list.get(i),i)){
        i = i + 2
      } else {
        i++
      }
    }
  }
  function _checkForSemicolon( lexeme : String, i : int) : boolean{
    var temp : List<String> = new ArrayList<String>(Arrays.asList(lexeme.split("")))
    var mainL : String = ""
    var subL : String = ""

    if(temp.size() == 1){
      return true
    } else {
      for (x in temp) {
        if (x.equals(";")) {
          mainL = lexeme.substring(0, lexeme.length() - 1)
          subL = ";"

          _list.set(i, mainL)
          _list.add(i + 1, subL)
          return true
        }
      }
      return false
    }
  }
  function _countSemiColons() : int{
    var counter : int = 0
    var i : int = _list.size()
    var x : int = 0
    while (x != i){
      if ( _list.get(x) == ";"){
        counter++
      }
      x++
    }
    return counter
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
        //Derivation
        System.out.print("\nDerivation\n")
        var d : Deri = new Deri(input)
        d.derivate()
        dump = sc.nextLine()

        //Parse Tree
        System.out.print("\nParse Tree\n")
        var p : PTree = new PTree(input)
        p.drawTree()
        dump = sc.nextLine()

        //Generating Output File
        System.out.print("\nGenerating File\n")
        var o : RobotFile = new RobotFile(lr.metaLangCode())
        o.generate()
        dump = sc.nextLine()
      } else {
        dump = sc.nextLine()
      }
    }
  }
}
//entry point for the whole program
program()