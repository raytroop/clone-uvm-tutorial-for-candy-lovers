## [UVM Tutorial for Candy Lovers – 21. TLM 1 Example](http://cluelogic.com/2014/04/uvm-tutorial-for-candy-lovers-tlm-1-example/)
- **Components**\
*We created the following components to demonstrate different kinds of TLM 1 interface. The jelly_bean_sequencer (the leftmost component) creates an object of the jelly_bean_transaction, called jb_req. The jb_req is transferred all the way to the right (jelly_bean_transporter) via several TLM 1 interfaces. The jelly_bean_transporter evaluates the flavor of the jb_req and returns another jelly_bean_transaction called jb_rsp (jelly-bean response) with the updated taste property. The jb_rsp is transferred back to the jelly_bean_subscriber at the end. Though this example is artificial, it will show you a variety of TLM 1 interfaces.*
- **Sample TLM 1 Connections**\
![Sample TLM 1 Connections](http://cluelogic.com/wp-content/uploads/2014/04/Tutorial_20_Example.png)
