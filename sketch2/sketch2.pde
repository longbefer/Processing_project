/*
*Task 2:Introduction to Computer Programming
*
*/
//全局变量
color bk_color=color(150,150,255);//背景色
color grassy_color=color(50,50,0);//灰草地
color sun_color=color(255,255,0);//太阳黄
color orbit_color=color(40,226,255);//轨道蓝
float sun_x=200.0f;//太阳的x位置
float cent_x=200.0f;//所有星系的中心x
float cent_y=200.0f;//所有星系的中心y
float t=0.50f;//透明度
//各星球的变量
int plant_num=5;//行星数量
float[] alpha=new float[plant_num];//各行星角度
float[] plant_r=new float[plant_num];//各行星的运行半径
float[] plant_speed=new float[plant_num];//各星球的速度
float[] plant_x=new float[plant_num];//各星球的x坐标
float[] plant_y=new float[plant_num];//各星球的y坐标
color[] plant_color=new color[plant_num];//各星球颜色
boolean[] plant_has=new boolean[plant_num];//是否绘制行星
//游戏部分
int sun_life=5;//火焰数量
int hit=0;//击中的数量
float precision=15.0f;//精度，碰撞响应范围
//火焰部分
int oval_max_num=sun_life;//火焰数目最大值
int oval_num=0;//发射的火焰数量
boolean[] oval_has=new boolean[oval_max_num];//判断每一个火焰是否还存在
float[] oval_x=new float[oval_max_num];//所有火焰的x坐标
float[] oval_y=new float[oval_max_num];//每一个火焰的位置
float oval_speed=6.0;//火焰下落速度

void setup(){
  size(400,400);//绘制窗口大小为400*400
  surface.setTitle("龙博峰");
  InitOrbit();//初始化星球坐标
  InitOval();//初始化火焰坐标
}

void draw(){
  background(bk_color);
  InitEnv();//移动时更新界面
  DrawTrace();//绘制轨迹
  DrawOrbit();//绘制天体
  DrawSun();//绘制太阳
  DrawOval();//绘制火焰
  ShowText();//显示文本
}

void InitOrbit(){//设置每个行星的位置，颜色
  for(int diameter=50;diameter<=250;diameter+=50)
    plant_r[(diameter-50)/50]=diameter/2;//设置每一个星球的运行半径
  //随机速度、位置和颜色
  for(int times=0;times<plant_num;times++){
    int R=(int)random(0,256);//0-255之间的随机数
    int G=(int)random(0,256);//R,G,B分别为颜色的三原色
    int B=(int)random(0,256);//随机产出颜色
    alpha[times]=random(0,360);//0-359之间的度数，作为初始角度
    plant_speed[times]=random(1,10);//1-9之间的数，表速度
    plant_color[times]=color(R,G,B);//每个随机颜色
    plant_x[times]=cent_x+plant_r[times]*cos(alpha[times]*PI/180);//星球x位置
    plant_y[times]=cent_y+plant_r[times]*sin(alpha[times]*PI/180);//星球y位置
    plant_has[times]=true;//绘制星球
  }
}

void InitOval(){//初始化火焰的位置
  for(int times=0;times<oval_max_num;times++){
    oval_has[times]=false;
    oval_x[times]=sun_x;//初始化位置为太阳的初始位置
    oval_y[times]=50;
  }
}

void InitEnv(){//初始化环境
  //远方
  stroke(grassy_color);
  fill(grassy_color);
  ellipse(200,400,400,100);  //绘制远方
}

void DrawTrace(){//绘制轨道
  for(int times=0;times<plant_num;times++){
    noFill();//不填充轨道中心
    strokeWeight(1);
    stroke(orbit_color);//设置轨道颜色
    ellipse(cent_x,cent_y,2*plant_r[times],2*plant_r[times]);
  }
}

void DrawOrbit(){//绘制星球
  for(int times=0;times<plant_num;times++){
    noStroke();
    fill(plant_color[times]);//填充随机的星球颜色
    if(plant_has[times]){//如果要绘制星球
      ellipse(plant_x[times],plant_y[times],25,25);//则绘制
      alpha[times]+=plant_speed[times];//重新设置旋转位置
      if(alpha[times]>=360)
        alpha[times]=0;//计算量限定，防止alpha溢出
      plant_x[times]=cent_x+plant_r[times]*
                      cos((alpha[times])*PI/180);
      plant_y[times]=cent_y+plant_r[times]*
                      sin((alpha[times])*PI/180);//并输出位置
    }else{//否则，不绘制星球，并且位置也为没有的值
      fill(0,0);//透明
      plant_x[times]=-50;//位置不在客户区内
      plant_y[times]=-50;
    }
  }
}

void DrawSun(){//绘制太阳
  //光晕的设计
  color get_sun_color=lerpColor(sun_color,bk_color,t);//颜色的线性插值
  stroke(get_sun_color);
  fill(get_sun_color);
  ellipse(sun_x,25,50,50);//光晕
  //太阳的设计
  stroke(sun_color);
  fill(sun_color);
  ellipse(sun_x,25,25,25);
}

void DrawOval(){//绘制火焰
  for(int times=0;times<oval_max_num;times++){
    if(oval_has[times]){//如果要绘制火焰
      MoveOval(times);//则绘制
      if(IsHitted(times))//判断是否击中星球
        SunAlive();//如果击中，判断是否结束
      if(oval_y[times]>=height){//判断是否越界
        oval_has[times]=false;//若越界，火焰消失
        SunAlive();//判断是否要结束
      }
    }else{//否则
      fill(0,0);//颜色改为透明
      oval_x[times]=sun_x;//位置为太阳位置
      oval_y[times]=25;
    }
  }
}

void ShowText(){ //显示结束时的文本
  textSize(20);//文本大小
  fill(51,118,187);//文本颜色
  text("Flames = "+sun_life,20,30);
  text("Hit = "+hit,20,60);
}

void MoveOval(int times){//绘制移动火焰
  fill(255,0,0);
  noStroke();
  ellipse(oval_x[times],oval_y[times],20,20);
  oval_y[times]+=oval_speed;//往下走
}

boolean IsHitted(int times){//判断times个火焰是否击中某个星球
  for(int i=0;i<plant_num;i++){
    if((abs(oval_x[times]-plant_x[i])<=precision)&&
        (abs(oval_y[times]-plant_y[i])<=precision)){//是否碰上火焰
      plant_color[i]=color(255,0,0);//行星颜色变化
      ellipse(plant_x[i],plant_y[i],25,25);//绘制此颜色
      plant_has[i]=false;//行星消失
      oval_has[times]=false;//火焰消失
      hit++;//击中加一
      return true;//返回击中
    }
  }
  return false;//返回未击中
}

void SunAlive(){//判断游戏是否可以继续
  boolean is_still_running=false;
  for(int times=0;times<oval_num;times++)//修复连射时，当所有都射出时一个出界时导致游戏结束
    if(oval_has[times]==true)//判断是否有火焰正在运行
      is_still_running=true;//若仍在运行，则暂时不结束程序
  if((sun_life<=0||hit==5)&&!is_still_running){//当没有火焰或击中了所有的星球并且没有火焰在运行
    background(bk_color);//刷新屏幕
    noLoop();//暂停绘制
    text("GAME OVER",125,150);//展示文本
    text("Flames = "+sun_life,125,220);
    text("Hit = "+hit,125,240);
    text("Plant Number ="+(oval_num-hit),125,260);
  }
}

//键盘事件
void keyPressed(){//按下键盘
  if(sun_life>0)//当火焰为0是不响应键盘事件
    switch(keyCode)
    {
      case LEFT: sun_x--;//向左移动太阳位置
                 if(sun_x<=0) sun_x=0;break;//判断太阳是否越界
      case RIGHT: sun_x++;//向右移动太阳位置
                  if(sun_x>=width) sun_x=width;break;//判断太阳是否越界
      case DOWN: oval_has[oval_num]=true;//发射的数量为oval_num
                 oval_x[oval_num++]=sun_x;//发射坐标为太阳的坐标
                 sun_life--;//火焰减少
                 break;
      default: break;
    }
}

/*
*参考资料 
*1，processing官网：https://processing.org/reference/
*/