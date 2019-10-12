/*
*Task 1:Introduction to Computer Programming
*
*/
//定义一个位置类
class Pos{
  public Pos(int x,int y){
    this.x=x;this.y=y;
  }
  public int x,y;//位置类包含两个数据成员x、y，分别代表坐标轴x和y
}

//全局变量
color bk_color=color(150,150,255);//背景色
color grassy_color=color(0,128,0);//草地绿
color sun_color=color(255,255,0);//太阳黄
color moon_color=color(255,255,255);//月亮白
float moon_x=0.0f;//移动的月亮x坐标
float moon_y=150.0f;//向下移动的月亮y坐标
float t=0.25f;//透明度
//定义类的对象（线的坐标）
Pos line1_s,line1_e,//第一条线的位置_s为起点，_e为终点
    line2_s,line2_e;//第二条线的位置

void setup(){
  size(400,400);//设置窗口大小
  surface.setTitle("龙博峰");
  InitLinePos();//初始化线的位置
}

void draw(){
  background(bk_color);//设置背景色
  InitEnv();//移动时更新界面
  DrawMoon();//绘制月亮
  DrawLine();//绘制线段
}

void InitLinePos(){//初始化线的位置
  line1_s=new Pos(0,0);//起点
  line1_e=new Pos(0,height);//第一条线的位置(终点)
  line2_s=new Pos(width,0);//起点
  line2_e=new Pos(width,height);//第二条线的位置
}

void InitEnv(){//初始化环境 //<>//
  //草地设计
  stroke(grassy_color);
  fill(grassy_color);
  ellipse(200,400,400,100);
  //太阳光晕设计
  color get_sun_color=Inter(sun_color,bk_color);//颜色的线性插值
  stroke(get_sun_color);
  fill(get_sun_color);
  ellipse(350,50,100,100);
  //太阳的设计
  stroke(sun_color);
  fill(sun_color);
  ellipse(350,50,50,50);
}

void DrawMoon(){//运行月亮
  float speed=3.0f;//速度
  if(moon_y>height)//判断月亮的路径，若月亮沉到草地以下可以选择不再绘制月亮 //<>//
     return;
  //不使用循环和判断，将月亮限制在线条内
  float fix_moon_x=moon_x;//修正实际月亮移动
  fix_moon_x=map(moon_x,0,width,line1_s.x,line2_s.x);//map()
  moon_x+=speed;//加速
  if(moon_x-25>width)//限制范围
     moon_x=-25;
  stroke(moon_color);
  fill(moon_color);
  /*没有视频链接，无法判断移动路径*/
  //ellipse(moon_x++,moon_y,25,25);//月亮移动
  ellipse(fix_moon_x,moon_y,25,25);//任务D的月亮移动
}

void DrawLine(){//绘制线段及其透明层
  //第一条线
  strokeWeight(5);//设置线的宽度
  VertLine(line1_s,line1_e);
  //第二条线
  strokeWeight(5);//设置线的宽度
  VertLine(line2_s,line2_e);
  //矩形阴影透明层
  noStroke();
  fill(255,50);//透明阴影
  rect(line1_s.x,line1_s.y,line2_e.x-line1_s.x,line1_e.y-line1_s.y);
}

void VertLine(Pos start,Pos end){//绘制三段不同颜色的线
   for(int times=0; times<3; times++){
     int gap_height=end.y-start.y;
    switch(times)//选取颜色
    {
     case 0:stroke(255,0,0);
            break;
     case 1:stroke(255,255,255);
            break;
     case 2:stroke(0,0,0);
            break;
     default: break;
    }
    line(start.x, start.y+times*(gap_height/3.0),
         start.x, start.y+(times+1)*(gap_height/3.0));
  } 
}

//鼠标滚动事件
void mouseWheel(MouseEvent event) {
  moon_y++;
}
//鼠标点击事件
void mouseClicked() {
  line1_s=new Pos(mouseX,0);
  line1_e=new Pos(mouseX,height);
  line2_s=new Pos(width-mouseX,0);
  line2_e=new Pos(width-mouseX,height);
}
//鼠标拖动事件
void mouseDragged() {
  mouseClicked();//拖动响应鼠标点击事件
}

//自定义线性插值
color Inter(color org_color,color bk_color){
  /*可以调用内置的lerpColor()函数来绘制渐变*/
  float R=t*red(org_color)+(1-t)*red(bk_color);
  float G=t*green(org_color)+(1-t)*green(bk_color);
  float B=t*blue(org_color)+(1-t)*blue(bk_color);
  color get_color=color(R,G,B);
  return get_color;
}


/*参考来源：
*1，如何在不使用条件语句和循环语句的情况下实现控制台输出1~100？：https://segmentfault.com/q/1010000003927008
*2，processing官网：https://processing.org/reference/
*/