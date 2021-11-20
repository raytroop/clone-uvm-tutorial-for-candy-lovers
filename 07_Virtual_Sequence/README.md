## [UVM Tutorial for Candy Lovers – 7. Virtual Sequence](http://cluelogic.com/2012/01/uvm-tutorial-for-candy-lovers-virtual-sequence/)
- **Overview**\
The first figure shows the relationship of the verification components used in this post. The jelly_bean_taster (DUT) from the previous posts was “enhanced” to take two jelly-bean flavors at the same time through two jelly_bean_ifs. This new DUT is referred to as the jelly_bean_taster_subsystem. To drive the two interfaces, two instances of jelly_bean_agent are used. The jelly_bean_recipe_virtual_sequence orchestrates the creation of jelly-bean flavors in order to make a new flavor. The second figure at the bottom of the page shows the verification components in a class diagram, and the third figure shows the verification objects in a class diagram.

- **Verification Platform**\
![Verification Platform](http://cluelogic.com/wp-content/uploads/2012/01/Jelly_bean1.png)
