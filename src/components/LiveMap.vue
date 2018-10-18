<template>
  <!--语音播报设置-->
  <div class='live-box'>
      <div class='wea-content'>
          <div class='wea-box'>
            <div class='news-box'>实时通报<span :class="['hasNew',{'new':hasNew}]">新消息</span></div>
            <ul class='news-list' @click='showToast()'>
                <li :class='{active:hasNew}'>{{news.new}}</li>
                <li class='newtime'>{{news.currtime}}</li>
            </ul>
            <!-- <div class='cover-box'></div> -->
            <audio preload="auto"
                src="./static/audio/warn.mp3" hidden id='audio'>
            </audio>
          </div>
          <div :class="['area-box',{hide:areaHide}]" @click='chooseArea()'>
              <div>{{currArea.gname}}</div>
              <ul>
                  <li v-for='(item,index) in areaList' :key='index' @click='changeArea(index)'>{{item.gname}}</li>
              </ul>
          </div>
      </div>
      <div class='set-box'>
          <div class='left-tab'>
              <ul class='tab-list'>
                  <li v-for="(item,index) in leftList" :key='index' :data-path='item.path' @click='changeActive(index)' :class='{active:item.isActive}'>
                      <span :class='setClass(item.class)'></span>
                      <p>{{item.title}}</p>
                  </li>
              </ul>
          </div>
          <div class='left-tab-line'>
              <ul class='tab-list'>
                  <li v-for="(item,index) in leftList" :key='index' :data-path='item.path' @click='changeActive(index)' :class='{active:item.isActive}'>
                      <span :class='setClass(item.class)'></span>
                  </li>
              </ul>
          </div>
          <div class='right-show-box'>
              <router-view v-bind:Gid='currArea.gid' @getPageNum='rcvMsg' v-if='currArea.gid>0'></router-view>
          </div>
      </div>
  </div>
</template>
<script>
  export default {
    data:function(){
      return{
          pageNum:1,
          leftList:[
              {class:'icon-bell-alt',title:'车辆到达',path:'cararrival',isActive:true,pageNum:11},
              {class:'icon-cloud',title:'特殊天气',path:'weather',isActive:false,pageNum:12},
              {class:'icon-comment',title:'紧急通知',path:'message',isActive:false,pageNum:13},
              {class:'icon-warning-sign',title:'车辆故障',path:'breakdown',isActive:false,pageNum:14},
              {class:'icon-phone',title:'指定人员',path:'toperson',isActive:false,pageNum:15}
            ],
          areaHide:true,
          areaList:[],
          currArea:{gid:0,gname:''},
          news:{nid: "0", new: "没有新消息", currtime: ''},
          timer:null,
          hasNew:false
       }
    },
    mounted:function(){
        this.$emit('getNum',this.pageNum);
        this.$http.post('http://lgkj.chuangkegf.com/groups.php',
        {kind:'select'},{emulateJSON:true}).then((res)=>{
            this.areaList = res.body;
            if(this.areaList.length > 0){
                if(!sessionStorage.getItem('currArea')){
                    this.currArea.gid = this.areaList[0].groupid;
                    this.currArea.gname = this.areaList[0].gname;
                    sessionStorage.setItem('currArea',this.areaList[0].groupid);
                }else{
                    var curr = parseInt(sessionStorage.getItem('currArea'));
                    this.currArea.gid = curr;
                    var hasArea = false;
                    for(var i=0;i<this.areaList.length;i++){
                        if(this.areaList[i].gid == curr) {
                            this.currArea.gname = this.areaList[i].gname;
                            sessionStorage.setItem('currArea',this.areaList[i].groupid);
                            hasArea = true;
                            break;
                        }
                    }
                    if(hasArea == false){
                        this.currArea.gid = this.areaList[0].groupid;
                        this.currArea.gname = this.areaList[0].gname;
                        sessionStorage.setItem('currArea',this.areaList[0].groupid);
                    }
                }
            }else{
                this.currArea.gid = 0;
                this.currArea.gname = '未分组';
            }
        })
        this.getNews();
        this.timer = setInterval(()=>{
            this.getNews();
        },3000)
    },
    beforeDestroy(){
        clearInterval(this.timer);
        this.timer = null;
    },
    methods:{
        setClass(path){
            return path;
        },
        showToast(){
            alert(this.news.new);
        },
        changeActive(index){
            for(var i=0;i<this.leftList.length;i++){
                this.leftList[i].isActive = false;
                if(i == index){
                    this.leftList[i].isActive = true;
                }
            }
            this.$router.push('/'+this.leftList[index].path);
        },
        rcvMsg(msg){
            for(var i=0;i<this.leftList.length;i++){
               if(msg == this.leftList[i].pageNum){
                  this.leftList[i].isActive = true;     
               }else{
                   this.leftList[i].isActive = false;
               }
            }
        },
        chooseArea(){
            if(this.areaHide == true){
                this.areaHide = false;
            }else{
                this.areaHide = true;
            }
        },
        changeArea(index){
            this.currArea.gid = this.areaList[index].groupid;
            this.currArea.gname = this.areaList[index].gname;
            sessionStorage.setItem('currArea',this.areaList[index].groupid);
        },
        getNews(){
            this.$http.get('http://lgkj.chuangkegf.com/getnew.php').then((res)=>{
                if(res.body != 'null'){
                    var lastNew = res.body;
                    var nid = localStorage.getItem('nid')?localStorage.getItem('nid'):'0';
                    if(lastNew[0] > nid){
                        this.news.nid = lastNew[0];
                        this.news.new = lastNew[1];
                        this.news.currtime = lastNew[2];
                        localStorage.setItem('nid',lastNew[0]);
                        var audio = document.getElementById('audio');
                        audio.play();
                        this.hasNew = true;
                    }else{
                        this.news.nid = lastNew[0];
                        this.news.new = lastNew[1];
                        this.news.currtime = lastNew[2];
                    }
                }
            })
        }
    }
  }
</script>

