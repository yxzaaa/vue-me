<template>
    <!--主页面-->
    <div class='index-box'>
        <div class='index-nav'>
            <div class='logo'><img src="../assets/images/logo.png" alt="" /></div>
            <div class='app-name'>{{appName}}&nbsp;&nbsp;<span>&nbsp;{{comName}}</span></div>
            <div class='user-tools'>
                <span class="icon-cog" @click='setSys()'></span>
                <span class="icon-off" @click='offSys()'></span>
            </div>
        </div>
        <div class='index-content'>
            <div :class="['left-nav',{'slide-left':slideToggle}]">
                <ul>
                    <li :class='{active:item.isActive}' v-for='(item,index) in navList' :key='index' @click="changePage(index,item.path)">
                        <span :class="[toggleIcon(item.icon),{'slide-left':slideToggle}]"></span>{{item.title}}<span v-if="item.isActive" :class="['rightItem',{'slide-left':slideToggle}]"></span>
                    </li>
                </ul>
                <div class='nav-toggle' @click='slide()'>
                    <span :class="['icon-indent-left',{'icon-indent-right':slideToggle}]"></span>
                </div>
            </div>
            <div class='left-nav-line'>
                <ul>
                    <li :class='{active:item.isActive}' v-for='(item,index) in navList' :key='index' @click="changePage(index,item.path)">
                        <span :class="toggleIcon(item.icon)"></span>
                    </li>
                </ul>
            </div>
            <div :class="['right-content',{'slide-left':slideToggle},{'set-toggle':setToggle}]">
                <router-view @getNum='rcvMsg'></router-view>
            </div>
            <div :class="['user-set',{'set-toggle':setToggle}]">
                <div class='set-avatar'>
                    <img src="../assets/images/avatar.png" alt="avatar" />
                </div>
                <div class='user-name-set'>{{userName}}</div>
                <div class='weather-box'>
                    <iframe name="weather_inc" src="http://i.tianqi.com/index.php?c=code&id=55"
                    style="border:solid 1px #7ec8ea" width="100%" height="100%" frameborder="0"
                    marginwidth="0" marginheight="0" scrolling="no"></iframe>
                </div>
            </div>
        </div>
    </div>
</template>
<script>
export default {
    data () {
        return {
            appName: '车辆语音播报系统',
            comName:'北京环威清洁服务有限公司',
            isAreaHide:true,
            currArea:'选择大区',
            navList:[
                {
                    title:'语音通知',
                    icon:'icon-bullhorn',
                    isActive:true,
                    path:'livemap',
                    pageNum:1
                },
                {
                    title:'分组管理',
                    icon:' icon-align-left',
                    isActive:false,
                    path:'infoctrl',
                    pageNum:2
                },
                {
                    title:'车辆信息',
                    icon:'icon-truck',
                    isActive:false,
                    path:'personctrl',
                    pageNum:3
                }
            ],
            userName:'未登录',
            uid:0,
            slideToggle:true,
            setToggle:false
        }
    },
    mounted(){
        this.$http.get('http://lgkj.chuangkegf.com/check.php').then((res)=>{
            if(res.body.code == 400){
                this.$router.replace('/login');
            }else if(res.body.code == 200){
                if(!sessionStorage.getItem('login')){
                    sessionStorage.setItem('login',true);
                }
                this.userName = res.body.uname;
                this.uid = res.body.uid;
            }
        },(err)=>{
            console.log(err);
        })
    },
    methods:{
        changePage(index,path){
            for(var i=0;i<this.navList.length;i++){
                this.navList[i].isActive = false;
            }
            this.navList[index].isActive = true;
            this.$router.push('/'+path);
        },
        toggleIcon(icon){
            return icon;
        },
        chooseArea(index){
            this.currArea = this.areaList[index];
            this.isAreaHide = true;
        },
        toggleAreaBox(){
            if(this.isAreaHide == true){
                this.isAreaHide = false;
            }else{
                this.isAreaHide = true;
            }
        },
        rcvMsg(msg){
            for(var i=0;i<this.navList.length;i++){
               if(msg == this.navList[i].pageNum){
                  this.navList[i].isActive = true;
               }else{
                   this.navList[i].isActive = false;
               }
            }
        },
        offSys(){
            if(confirm('退出系统？')){
                var userid = localStorage.getItem('userid');
                if(userid){
                    this.$http.post('http://lgkj.chuangkegf.com/logout.php',
                    {
                        userid:userid,
                    },{emulateJSON:true}).then((res)=>{
                        console.log(res.body);
                        if(res.body.code == 200){
                            this.$router.replace('/login');
                        }
                    },(err)=>{
                        console.log(err);
                    })
                }else{
                    alert('登录状态异常，无法退出！');
                }
            }
        },
        slide(){
            if(this.slideToggle == true){
                this.slideToggle = false;
            }else{
                this.slideToggle = true;
            }
        },
        setSys(){
            if(this.setToggle == true){
                this.setToggle = false;
            }else{
                this.setToggle = true;
            }
        }
    }
}
</script>
