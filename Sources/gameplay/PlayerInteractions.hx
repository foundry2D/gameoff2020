package gameplay;

import found.Trait;

class PlayerInteractions extends Trait{
    public function new(){
        super();
        notifyOnUpdate(update);
        notifyOnRender2D(render2d);
    }
    function update(dt:Float){

    }
    function render2d(g:kha.graphics2.Graphics) {
        g.color = kha.Color.Red;

        g.fillRect(this.object.position.x,this.object.position.y,100,100);
        g.color = kha.Color.White;
    }
}