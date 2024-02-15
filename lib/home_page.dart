import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';


class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _HomePageState();

}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin{

  bool isOpened = false;
  late TabController tabController;


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Student Portal'),
        bottom: new TabBar(controller: tabController,tabs: <Widget>[
          new Tab(
            icon: new Icon(Icons.playlist_add),
            text: "Outpass",
          ),
          new Tab(
            icon: new Icon(Icons.arrow_forward,),
            text: "Leave",
          ),
          new Tab(
            icon: new Icon(Icons.announcement,),
            text: "Complaints",
          )
        ],
        ),

      ),

      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            new UserAccountsDrawerHeader(accountName: new Text("Aman Singhal",style: new TextStyle(fontSize: 20.0),), accountEmail: new Text("aman0550singhal@gmail.com",),
              currentAccountPicture: new CircleAvatar(
                backgroundImage: new AssetImage("assets/profile.jpg"),
              ),
            ),
            new ListTile(
              title: new Text("Edit Profile",style: new TextStyle(fontSize: 17.0),),
              trailing: new Icon(Icons.create),
              onTap: (){},

            ),
            new ListTile(
              title: new Text("Setting",style: new TextStyle(fontSize: 17.0)),
              trailing: new Icon(Icons.settings),
              onTap: (){},

            ),
            new Divider(),
            new ListTile(
              title: new Text("Help",style: new TextStyle(fontSize: 17.0)),
              trailing: new Icon(Icons.help),
              onTap: (){},

            ),
            new ListTile(
              title: new Text("Send Feedback",style: new TextStyle(fontSize: 17.0)),
              trailing: new Icon(Icons.feedback),
              onTap: (){},

            ),
            new ListTile(
              title: new Text("About",style: new TextStyle(fontSize: 17.0)),
              trailing: new Icon(Icons.info),
              onTap: (){},

            ),
            new ListTile(
              title: new Text("Log Out",style: new TextStyle(fontSize: 17.0)),
              trailing: new Icon(Icons.exit_to_app),
              onTap: (){
                FirebaseAuth.instance.signOut().then((value){
                  Navigator.of(context).pushReplacementNamed('/landingpage');
                }).catchError((e){print(e);});
              },

            ),


          ],
        ),
      ),


    );
  }

}

class RoomBookingPage extends StatefulWidget {
  @override
  _RoomBookingPageState createState() => _RoomBookingPageState();
}

class _RoomBookingPageState extends State<RoomBookingPage> {
  List<String> rooms = ['Single Room', 'Double Room', 'Dormitory'];

  late String selectedRoom;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedRoom,
              items: rooms.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              hint: Text('Select Room Type'), onChanged: (String? value) {  },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Proceed to payment
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaymentPage(selectedRoom)),
                );
              },
              child: Text('Proceed to Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentPage extends StatefulWidget {
  final String selectedRoom;

  PaymentPage(this.selectedRoom);

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late Razorpay _razorpay;
  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Handle payment success
    print("Payment Success: ${response.paymentId}");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PaymentSuccessPage()),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Handle payment failure
    print("Payment Error: ${response.code} - ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Handle external wallet
    print("External Wallet: ${response.walletName}");
  }

  void _openCheckout() {
    var options = {
      'key': 'YOUR_RAZORPAY_KEY',
      'amount': 2000, // amount in the smallest currency unit
      'name': 'Hostel Booking',
      'description': 'Room Booking Payment',
      'prefill': {'contact': '1234567890', 'email': 'test@example.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Error: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selected Room: ${widget.selectedRoom}'),
            SizedBox(height: 20),
            Text('Payment Methods'),
            ElevatedButton(
              onPressed: () {
                _openCheckout();
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Success'),
      ),
      body: Center(
        child: Text('Payment Successful!'),
      ),
    );
  }
}