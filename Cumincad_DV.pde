void setup() {
  size (600, 600);
  smooth();
  background(0);
  guiSetup();
  allWebPages = new ArrayList <WebPage>();
  urls = new ArrayList <String>();
  tableSetup();
  
  
  
  
  
  
  
}

void draw() {
  background(0);
  // cp5.draw();
  text("Current database is: " + currentDB, guilocX, height - 35);

  if (!fetched) {
    text("Press Fetch button to fetch this database, then press Generate button to generate data. You can set the fetch depth by the slider", 20, height-20);
  }
  if (fetched && !generate) {
    text("Fetching process is done. Now press Generate button to generate data!", 20, height-20);
  }
  if (generate) {
    text("Hover your mouse left and right to see different results.", 20, height-20);
  }
  displayResults();
}

void guiSetup() {



  cp5 = new ControlP5(this);
  //cp5.setAutoDraw(false);
  l = cp5.addListBox("myList")
    .setPosition(guilocX, height - guilocYOffset-5)
      .setSize(120, 120)
        .setItemHeight(15)
          .setBarHeight(20)
            .setColorBackground(color(255, 128))
              .setColorActive(color(0))
                .setColorForeground(color(255, 100, 0))
                  ;

  l.captionLabel().toUpperCase(true);
  l.captionLabel().set("Data Base List");
  l.captionLabel().setColor(255);
  l.captionLabel().style().marginTop = 3;
  l.valueLabel().style().marginTop = 3;
  for (int i=0; i<dataBases.length; i++) {
    ListBoxItem lbi = l.addItem(dataBases[i], i);
    lbi.setColorBackground(255);
  }

  cp5.addSlider("fetchDepth")
    .setPosition(guilocX + 130, height - guilocYOffset + 30)
      .setSize(60, 80)
        .setNumberOfTickMarks(25)
          .setRange(0, 100)
            .setValue(75)
              ;
  cp5.addButton("fetch", 0, guilocX + 130, height - guilocYOffset, 60, 20);
  cp5.addButton("generate", 0, guilocX + 130, height - guilocYOffset - 25, 60, 20);
}


void controlEvent(ControlEvent theEvent) {
  if (theEvent.isGroup()) {
    int indexDB = int (theEvent.group().value());
    url = urlTemp_00+dataBases[indexDB]+ urlTemp_02;
    println(url);
    currentDB = dataBases[indexDB];
  }
}

void fetch (int theValue) {
  webSource = loadStrings(url);  
  println(url);
  background(0);
  generateUrl();
  fetchUrl();
  fetched =true;

  if (fetched) {
    for (int i = 0; i < allWebPages.size (); i ++) {
      WebPage webPage = allWebPages.get(i);
      webPage.run();
      generate = true;
    }


    for (int i = 0; i< allWebPages.size (); i++) {
      WebPage webPage = allWebPages.get(i);
      webPage.inDepth();
      println("In depth fetch for depth "+ (i+1) + " / "+allWebPages.size ()+ " is done!");
    }
    println(" for loop is done!");
    preWritetoTable();
    println("preWritetoTable is done!");
    saveTable(table, "data/new.csv");
    println("saveTable is done!");
  }
}

void generate (int theValue) {
  if (fetched) {
    for (int i = 0; i < allWebPages.size (); i ++) {
      WebPage webPage = allWebPages.get(i);
      //println("webPage"+i+":"+webPage.rawText);
      webPage.run();
      generate = true;
    }
  } else {
    background(0);
    text("Please fetch the website first, by pressing Fetch key!", width/2, height/2);
  }
}

void generateUrl() {
  webSource = loadStrings(url);  
  for (int i = urls.size ()-1; i >= 0; i --) {
    urls.remove(i);
  }
  for (int i = 0; i < fetchDepth; i ++) {
    String tempUrl = url + str(20*i);
    urls.add(tempUrl);
  }
}

void fetchUrl() {
  for (int i = allWebPages.size ()-1; i >= 0; i --) {
    allWebPages.remove(i);
  }

  String tempUrl = urls.get(0);
  webSource = loadStrings(tempUrl);
  testSize = webSource.length;
  for (int i = 0; i < fetchDepth; i ++) {
    String tempUrl_ = urls.get(i);
    webSource = loadStrings(tempUrl_);
    if (testSize - webSource.length < 200) {
      println(tempUrl_+ "\nIs Done!");
      println(webSource.length);
      allWebPages.add(new WebPage(tempUrl_, webSource));
    } else {
      i =fetchDepth;
      println("The fetch process is completed.");
    }
  }
}


void displayResults() {

  if (generate) {
    float index_ = map(mouseX, 0, width, 0, allWebPages.size ());
    int index =  int(index_);
    WebPage webPage = allWebPages.get(index);
    //webPage.display();
  }
}


void keyPressed() {
  if (key == 'c') {

    saveFrame("###frame.jpg");
  }

  if (key == 'd'|| key =='D') {
    for (int i = 0; i< allWebPages.size (); i++) {
      WebPage webPage = allWebPages.get(i);
      webPage.inDepth();
      println("In depth fetch for depth "+ (i+1) + " / "+allWebPages.size ()+ " is done!");
    }
      preWritetoTable();
    saveTable(table, "data/new.csv");
  }

  if (key == 'e'|| key =='E') {
    preWritetoTable();
    saveTable(table, "data/new.csv");
    
  }
}

void tableSetup() {
  table = new Table();
  table.addColumn("#");
  table.addColumn("Title");
  table.addColumn("Author");
  table.addColumn("Database");
  table.addColumn("Year");
  table.addColumn("Keywords");
  table.addColumn("Abstract");
}

void preWritetoTable() {
  
  println("The preWritetoTable process is beginning.");
  for (int i = 0; i< allWebPages.size (); i++) {
    //println("The preWritetoTable process is beginning: "+i);
    WebPage webPage = allWebPages.get(i);
    //println("webPage"+i+":"+webPage.rawText);
    //println("webpage: "+i);
    webPage.writeTable();
    //println("webpage writetable: "+i);

  }
}


Table table;

String urlTemp_00 = "http://papers.cumincad.org/cgi-bin/works/BrowseTree?field=series&separator=:&recurse=0&order=AZ&value=";
String urlTemp_02 = "&first=";

String dataBases [] = {
  "ACADIA", "ASCAAD", "AVOCAAD", "CAAD%20Futures", "CAADRIA", "CADline", "DDSS", "EAEA", "SIGRADI", "book", "eCAADe", "journal%20paper", "otherplCAD", "report"
}
;

String url = "http://papers.cumincad.org/cgi-bin/works/BrowseTree?field=series&separator=:&recurse=0&order=AZ&value=ACADIA&first=";
String dataBaseName;
String webSource[] = loadStrings(url);
int testSize =0;
ArrayList <WebPage> allWebPages;
ArrayList <String> urls;
boolean fetched =false;
boolean generate = false;
int fetchDepth = 75;
String currentDB = "ACADIA";
String [] siteCode; 
String [] siteCodeDetail;
//Control P5

int guilocX = 20;
int guilocYOffset = 200;
import controlP5.*;
ControlP5 cp5;
String textValue = "";

Textfield myTextfield;

ListBox l;
int cnt = 0;

class WebPage {
  String code [];
  String rawText [];

  String links [];
  String titles [];
  String authors [];
  String years [];
  String keyWords [] = new String [20];
  String Abstract[]= new String [20];

  String splittedText_ [];
  String splittedText [];
  String url;
  String mainLink = "http://papers.cumincad.org/";
  WebPage (String _url, String _code[]) {
    code = _code;
    url = _url;
    rawText = trim(code);
  }

  void run() {
    //println(rawText);
    fetchLink();
    fetchTitle();
    fetchAuthor();
    fetchYear();
    background(0);
    display();
  }

  void writeTable() {
    println("writetable beginning ");
    for (int i = 0; i < titles.length; i++) {
      //println("newRow: "+ i);
      TableRow newRow = table.addRow(); 
      //println("table:addRow: "+ i);
      newRow.setInt("#", table.lastRowIndex());
      //println("table:addRow: set Title"+ i); 
      newRow.setString("Title", titles[i]); 
      //println("table:addRow: set authors"+ i); 
      newRow.setString("Author", authors[i]); 
      //println("table:addRow: set currentDB"+ i); 
      newRow.setString("Database", currentDB); 
      //println("table:addRow: set years"+ i); 
      newRow.setString("Year", years[i]);
      //println("table:addRow: set keys"+ i); 
      newRow.setString("Keywords", keyWords[i]);
      //println("table:addRow: set abs"+ i); 
      newRow.setString("Abstract", Abstract[i]);
    }
  }
  void fetchLink() {
    println("Link");
    links= globalFetch( "<td><A HREF=", ">"  );
    /*/for (int i = 0; i < links.length; i++) {
      //links[i] = mainLink+links[i];
      
      println("Link"+i+":"+links[i]);
    }*/
  }

  void fetchTitle() {
    println("Title");
    titles = globalFetch( "<B>", "</B></A>"  );
    /*for (int i = 0; i < titles.length; i++) {
      println("Title"+i+":"+titles[i]);
    }*/
  }

  void fetchAuthor() {
    println("Author");
    authors = globalFetch( "</td> <td valign=\"top\">", " ("  );
    /*for (int i = 0; i < authors.length; i++) {
      println("Author"+i+":"+authors[i]);
    }*/
  }

  void fetchYear() {
    println("Year");
    years = globalFetch( "</td> <td valign=\"top\">", ")"  );
    for (int i = 0; i < years.length; i++) {
      String years_ [] = splitTokens(years[i], "(");
      years [i] = years_[1];
      //println("Year"+i+":"+years[i]);
    }
  }

  void inDepth() {
    for (int i = 0; i < splittedText.length; i++) {
      siteCode = loadStrings(links[i]);
      interact(siteCode, i);
      //println("Number of Pages checked = " + (i+1));
    }
  }


  void display() {

    for (int i = 0; i < splittedText.length; i++) {
      textSize(14);
      text ( titles[i], 20, 20+ 30*i);
      textSize(10);
      text ("Authour(s): " + authors[i] + " | " + years[i], 20, 30+ 30*i);

      if (mouseY > 20+ 30*(i-1) && mouseY < 20+ 30*(i)) {
        text(links [i], 20, height-5);
        if (mousePressed == true) {
        }
        siteCode = loadStrings(links[i]);
        interact(siteCode, i);
      }
    }
  }

  void interact(String [] siteData_, int index_) {
    //println("interact:"+siteData_);
    //println(siteData_);
    String [] keyWordsDetail = detailFetch(siteData_, "<meta name=\"DC.subject\" content=\"", "\"");
    //println(keyWordsDetail);
    String [] abstractDetail = detailFetch(siteData_, "<meta name=\"DC.description\" content=\"", "\"");
    //println(abstractDetail);
    //for (int i=0; i<keyWordsDetail.length; i++)
      //keyWords [i]= keyWordsDetail[i];
    //for (int i=0; i<abstractDetail.length; i++)
      //Abstract[i] = abstractDetail[i];
    textSize(14);
    text ( titles[index_] + "\nAuthour(s): " + authors[index_] + " | " + years[index_], guilocX + 250, height - guilocYOffset -100, 700, 50);
    textSize(10);
    text("Keywords: " + keyWordsDetail[0], guilocX + 250, height - guilocYOffset -50, 700, 50);
    text(abstractDetail[0], guilocX + 250, height - guilocYOffset -25, 700, 200);
    //println("interact off");
  }


  String [] globalFetch (String term1, String term2) {
    String rawTextJoin = join(rawText, ",");
    splittedText_ = split(rawTextJoin, term1);
    splittedText = new String [splittedText_.length-1];
    for (int i = 1; i < splittedText_.length; i++) {
      String tempText [] = split(splittedText_[i], term2);
      splittedText[i-1] = tempText[0];
    }

    return splittedText;
  }


  String [] detailFetch (String [] mainText, String term1, String term2) {
    String rawTextJoin = join(mainText, ",");
    String [] st_ = split(rawTextJoin, term1);
    String [] st = new String [st_.length-1];
    for (int i = 1; i < st_.length; i++) {
      String tempText [] = split(st_[i], term2);
      st[i-1] = tempText[0];
      //println(st[i-1]);
    }
    return st;
  }
}
