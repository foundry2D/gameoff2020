package gameplay;

import found.State;
import echo.Body;
import echo.data.Data.CollisionData;
import found.Trait;
import found.object.Collidable;
import found.object.Object.CollisionDef;


class PlayerInteractions extends Trait implements Collidable{
    var hpuzzle:HammingUi;
    public function new(){
        super();
        notifyOnInit(init);
        notifyOnRemove(exit);
        notifyOnUpdate(update);
        notifyOnRender2D(render2d);
    }
    var listeners:Array<echo.Listener>;
    function init(){
        hpuzzle = State.active.getObject("camera").getTrait(HammingUi);
        var def:CollisionDef = {
            objectName: "Interactable",
            onEnter: onEnter,
            onExit: onExit
        }
        listeners = this.object.onCollision(def);
    }
    private function onEnter(me:Body,other:Body, data:Array<CollisionData>):Void{
        hpuzzle.enter();
    }
    private function onStay(me:Body,other:Body, data:Array<CollisionData>):Void{}
    private function onExit(me:Body,other:Body):Void{
        hpuzzle.exit();
    }
    function exit(){
        this.object.removeCollisionListeners(listeners);
    }
    function update(dt:Float){

    }
    function render2d(g:kha.graphics2.Graphics) {
        g.color = kha.Color.Blue;

        g.fillRect(this.object.position.x,this.object.position.y,100,100);
        g.color = kha.Color.White;
    }
}