package ;

class First extends ru.stablex.ui.widgets.Text {

    public function new() {
        super();
        this.top = 100;
        this.text = 'My first widget!';
        this.left = 50;
        this._onInitialize();
        this._onCreate();
    }
}
