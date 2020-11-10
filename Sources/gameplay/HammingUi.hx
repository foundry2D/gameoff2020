package gameplay;

import found.Event;
import found.math.Util;
import found.trait.internal.CanvasScript;
import haxe.Json;
import haxe.io.Bytes;
import kha.Blob;
import zui.Canvas;
import zui.Id;
import zui.Themes;

class HammingUi extends CanvasScript {
    var c:TCanvas;
    var w:Int = 512;
    var h:Int = 512;
    var elemSize:Int;
    var foundSolution = false;
    var writeText = false;
    var tryCount = 0;
    inline static var chara = '>';
    inline static var dd = "\n\n\n\n\n\n";
    inline static var grid = 4;
    public function new() {
        Canvas.themes.push(Themes.dark);
        var hammingElems = [];
        var top = Std.int(w* 0.25);
        elemSize = Std.int((w - w* 0.25) / grid);
        var textZone:TElement ={
            id: Util.random(Std.int(Date.now().getTime())),
            type: TextArea,
            name: "TextZone",
            x: 0,
            y: 0,
            width: Std.int(w * 0.75),
            height: top,
            text: dd,
            editable: false
        }
        var but1:TElement = {
            id: Util.random(Std.int(Date.now().getTime())) + 1,
            type: Button,
            name: "EnterButton",
            x: textZone.width,
            y: 0,
            width: w - textZone.width,
            height: Std.int(top * 0.5),
            text: "Enter"
        }
        var but2:TElement = {
            id: Util.random(Std.int(Date.now().getTime())) + 2,
            type: Button,
            name: "ExitButton",
            x: textZone.width,
            y: Std.int(top * 0.5),
            width: w - textZone.width,
            height: Std.int(top * 0.5),
            text: "Exit",
            event: "HammExit"
        }
        hammingElems.push(textZone);
        hammingElems.push(but1);
        hammingElems.push(but2);
        for(x in 0...grid){
            for(y in 0...grid){
                var elem:TElement = {
                    id: x+y,
                    type: Button,
                    name: 'c$x;r$y',
                    x: elemSize * x,
                    y: elemSize * y + top,
                    width: elemSize,
                    height: elemSize,
                    text: Std.string(Util.randomRangeInt(0,1)),
                    event: 'c$x;r$y;Event'
                }
                hammingElems.push(elem);
            }
        }
        c = {
            name: "HammingPuzzle",
            x: 0,
            y: 0,
            width: w,
            height: h,
            elements: hammingElems,
            theme: Themes.dark.NAME,
        }
        var c_blob = Blob.fromBytes(Bytes.ofString(Json.stringify(c)));
        super("","font_default.ttf",c_blob);
        notifyOnAwake(exit);
        notifyOnUpdate(update);
        Event.add("HammExit",exit);
        Event.add('c1;r0;Event',parityCheck1);
        Event.add('c2;r0;Event',parityCheck2);
        Event.add('c0;r1;Event',parityCheck4);
        Event.add('c0;r2;Event',parityCheck8);
        for(x in 0...grid){
            for(y in 0...grid){
                if( (x == 0 && y == 1) || (x == 0 && y == 2) || (x == 1 && y == 0) || (x == 2 && y == 0) ){
                    continue;
                }
                Event.add('c$x;r$y;Event',checkIfValidChoice);
            }
        }
    }
    function checkIfValidChoice(args:Array<Dynamic>){
        var name:String = args[0];
        var col = Std.parseInt(name.substr(name.indexOf('c')+1,1));
        var row = Std.parseInt(name.substr(name.indexOf('r')+1,1));
        var index = -1;
        for(x in 0...grid){
            for(y in 0...grid){
                index++;
                if(x == col && row == y && index == noise[0]){
                    foundSolution = true;
                    animateCount = 0.0;
                }
            }
        }
        if(!foundSolution){
            tryCount++;
        }
    }
    function resetGrid(){
        var index = -1;
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                elem.color = null;
            }
        }
    }

    function parityCheck1() {
        var index = -1;
        var errCol:Array<Int> = [];
        var telm = this.getElement('c1;r0');
        if(telm.color == kha.Color.Blue || telm.color == kha.Color.Yellow ){
            resetGrid();
            return;
        }
        resetGrid();
        //Check
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if((x == 1 || x == 3) && solution[index] != Std.parseInt(elem.text)){
                    errCol.push(x);
                }
            }
        }
        //Draw
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if(x == errCol[0]){
                    elem.color = kha.Color.Yellow;
                }
                else if(x==1 || x==3){
                    elem.color = kha.Color.Blue;
                }
            }
        }
        trace(errCol);
    }
    function parityCheck2() {
        var index = -1;
        var errCol:Array<Int> = [];
        var telm = this.getElement('c2;r0');
        if(telm.color == kha.Color.Blue || telm.color == kha.Color.Yellow ){
            resetGrid();
            return;
        }
        resetGrid();
        //Check
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if((x == 2 || x == 3) && solution[index] != Std.parseInt(elem.text)){
                    errCol.push(x);
                }
            }
        }
        //Draw
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if(x == errCol[0]){
                    elem.color = kha.Color.Yellow;
                }
                else if(x == 2 || x==3){
                    elem.color = kha.Color.Blue;
                }
            }
        }
    }
    function parityCheck4() {
        var index = -1;
        var errCol:Array<Int> = [];
        var telm = this.getElement('c0;r1');
        if(telm.color == kha.Color.Blue || telm.color == kha.Color.Yellow ){
            resetGrid();
            return;
        }
        resetGrid();
        //Check
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if((y == 1 || y == 3) && solution[index] != Std.parseInt(elem.text)){
                    errCol.push(y);
                }
            }
        }
        //Draw
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if(y == errCol[0]){
                    elem.color = kha.Color.Yellow;
                }
                else if(y == 1 || y==3){
                    elem.color = kha.Color.Blue;
                }
            }
        }
    }
    function parityCheck8() {
        var index = -1;
        var errCol:Array<Int> = [];
        var telm = this.getElement('c0;r2');
        if(telm.color == kha.Color.Blue || telm.color == kha.Color.Yellow ){
            resetGrid();
            return;
        }
        resetGrid();
        //Check
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if((y == 2 || y == 3) && solution[index] != Std.parseInt(elem.text)){
                    errCol.push(y);
                }
            }
        }
        //Draw
        for(x in 0...grid){
            for(y in 0...grid){
                index +=1;
                var elem = this.getElement('c$x;r$y');
                if(y == errCol[0]){
                    elem.color = kha.Color.Yellow;
                }
                else if(y == 2 || y==3){
                    elem.color = kha.Color.Blue;
                }
            }
        }
    }
    var textHandle = Id.handle();
    var accumulator:Float = 0.0;
    var cursorInterval:Float = 0.5;
    var animate:Bool = false;
    var animateTime:Float = 2.0;
    var animateInterval:Float = 0.2;
    var animateCount:Float = 0.0;
    var solution:Array<Int> = [];
    var noise:Array<Int> = [];
    function update(dt:Float){
        if(!this.visible) return;
        accumulator += dt;
        var accumulator_t = accumulator;
        animateCount += dt;
        if(accumulator > cursorInterval){
            var tZone = this.getElement("TextZone");
            if(StringTools.contains(tZone.text, chara)){
                tZone.text = StringTools.replace(tZone.text,chara,'');
            }
            else {
                if(tZone.text == dd){
                    tZone.text = chara+tZone.text;
                }
                else{
                    tZone.text += chara; 
                }
                
            }
            accumulator = 0.0;
        }
        if(animate){
            if(animateCount > animateInterval){
                for(x in 0...grid){
                    for(y in 0...grid){
                        var elem = this.getElement('c$x;r$y');
                        var col = kha.Color.fromValue(Util.random(x+y+ Util.randomInt(50)));
                        col.A =1.0;
                        elem.color = col;
                        elem.text = Std.string(Util.randomRangeInt(0,1));
                    }
                }
            }
            if(animateCount > animateTime){
                solution.splice(0,solution.length);
                noise.splice(0,noise.length);
                animate = false;
                noise.push(Util.randomRangeInt(3,15));
                if(noise[0] == 4) noise[0] = Util.randomRangeInt(5,15);
                if(noise[0] == 8) noise[0] = Util.randomRangeInt(9,15);
                var index = -1;
                for(x in 0...grid){
                    for(y in 0...grid){
                        index +=1;
                        var elem = this.getElement('c$x;r$y');
                        elem.color = null;
                        solution.push(Util.randomRangeInt(0,1));
                        if(noise[0] == index){
                            elem.color = kha.Color.Red;
                            elem.text = Std.string(solution[index] == 0 ? 1:0);
                        }
                        else{
                            elem.text = Std.string(solution[index]);
                        }
                    }
                }
            }
        }
        if(foundSolution || tryCount == 3){
            if(accumulator_t > cursorInterval * 0.75){
                for(x in 0...grid){
                    for(y in 0...grid){
                        var elem = this.getElement('c$x;r$y');
                        var col = tryCount < 3 ? kha.Color.Green : kha.Color.Red;
                        elem.color = elem.color == col  ? null: col;
                        elem.text = Std.string(Util.randomRangeInt(0,1));
                    }
                }
                accumulator = 0.0;
            }
            if(animateCount > animateTime){
                resetGrid();
                foundSolution = false;
                writeText = true;
            }
        }
        if(writeText){

        }
    }
    public function enter(){
        this.visible = true;
        tryCount = 0;
        animateCount = 0.0;
        animate = true;
    }
    public function exit(){
        this.visible = false;
    }
}