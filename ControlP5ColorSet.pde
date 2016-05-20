import controlP5.*;

class ControlP5ColorSet {
    color enabled_bg;
    color enabled_fg;
    color enabled_ac;
    color disabled_bg;
    color disabled_fg;
    color disabled_ac;

    ControlP5ColorSet(color e_bg, color e_fg, color e_ac,
                      color d_bg, color d_fg, color d_ac) {
        enabled_bg = e_bg;
        enabled_fg = e_fg;
        enabled_ac = e_ac;
        disabled_bg = d_bg;
        disabled_fg = d_fg;
        disabled_ac = d_ac;
    }

    void assignColorsToController(Controller ctrl, boolean enabled) {
        if (enabled) {
            ctrl.setColorBackground(enabled_bg);
            ctrl.setColorForeground(enabled_fg);
            ctrl.setColorActive(enabled_ac);
        }
        else {
            ctrl.setColorBackground(disabled_bg);
            ctrl.setColorForeground(disabled_fg);
            ctrl.setColorActive(disabled_ac);
        }
    }
}
