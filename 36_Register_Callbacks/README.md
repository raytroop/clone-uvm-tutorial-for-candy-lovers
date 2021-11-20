## [UUVM Tutorial for Candy Lovers – 36. Register Callbacks](http://cluelogic.com/2016/08/uvm-tutorial-for-candy-lovers-register-callbacks/)
*In some design, when one register is written, another register takes a new value. This article will explain how to model this behavior using a register callback.*

```verilog
jb_recipe_reg_cb = jelly_bean_recipe_reg_callback::type_id::create( "jb_recipe_reg_cb" );
jb_recipe_reg_cb.jb_taste_reg = jb_reg_block.jb_taste_reg;
uvm_reg_cb::add( jb_reg_block.jb_recipe_reg, jb_recipe_reg_cb );
```

- Register Values in the **DUT** after Write\
![Register Values in the **DUT** after Write](http://cluelogic.com/wp-content/uploads/2016/08/RAL-3.png)

- Register Values in the **Model** after Write\
![Register Values in the **Model** after Write](http://cluelogic.com/wp-content/uploads/2016/08/RAL-3.png)
