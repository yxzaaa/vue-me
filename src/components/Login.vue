<template>
    <div class='login-box'>
        <div class='back-image'>
            <img src="../assets/images/bg.jpg" alt="" />
        </div>
        <div class='copy-right'>{{copyRight}}</div>
        <div class='login-content'>
            <div class='sys-title'>{{sysTitle}}</div>
            <div class='com-name'>{{comName}}</div>
            <div class='user-name'>
                <span class='icon-user'></span>
                <input type="text" v-model='userName' autocomplete="off" :class='{error:hasError}' placeholder="请输入用户名"/>
            </div>
            <div class='user-pwd'>
                <span class='icon-lock'></span>
                <input type="password" v-model='userPwd' autocomplete="new-password" :class='{error:hasError}' placeholder='请输入密码'/>
            </div>
            <div class='stayIn'><span :class="['icon-ok',{stayActive:stay}]" @click='setStay()' id='1'></span><label for='1'>始终令我保持登录状态</label></div>
            <div class='login-btn' @click='login()'>登录</div>
        </div>
    </div>
</template>
<script>
export default {
    data(){
        return {
            sysTitle:'车辆语音播报系统',
            comName:'北京环威清洁服务有限公司',
            userName:'',
            userPwd:'',
            hasError:false,
            copyRight:'雷光网络科技有限公司',
            stay:false,
            prjid:1
        }
    },
    mounted(){
        var userid = localStorage.getItem('userid');
        if(userid){
            this.$http.post('http://lgkj.chuangkegf.com/login.php',
            {
                userid:userid,
                kind:'check'
            },{emulateJSON:true}).then((res)=>{
                console.log(res.body);
                if(res.body.code == 200){
                    localStorage.setItem('uname', res.body.uname);
                    this.$router.replace('/');
                }
            },(err)=>{
                console.log(err);
            })
        }
    },
    methods:{
        login(){
            if(this.userName != '' && this.userPwd != ''){
                this.$http.post('http://lgkj.chuangkegf.com/login.php',
                {
                    uname:this.userName,
                    upwd:this.userPwd,
                    statelog:this.stay == true?1:0,
                    prjid:this.prjid,
                    kind:'login'
                },{emulateJSON:true}).then((res)=>{
                    console.log(res.body);
                    if(res.body.code == 200){
                        localStorage.setItem('userid', res.body.userid);
                        localStorage.setItem('uname', this.userName);
                        this.$router.replace('/');
                    }else if(res.body.code == 400){
                        this.hasError = true;
                        setTimeout(()=>{
                            this.hasError = false;
                        },300);
                    }
                },(err)=>{
                    console.log(err);
                })
            }
        },
        setStay(){
            if(this.stay == false){
                this.stay = true;
            }else{
                this.stay = false;
            }
        }
    }
}
</script>

