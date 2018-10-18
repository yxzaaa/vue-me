<template>
    <div class='vel-set-box'>
        <ul class='vel-list'>
            <li v-for='(item,index) in velList' :key='index'>
                <div class="vel-info">
                    <span class='vel-num'>{{item.num}}</span>
                    <span class='vel-kind'>{{item.speed}}</span>
                    <span class='vel-brand'>{{item.state}}</span>
                    <span class='vel-area'>{{item.location}}</span>
                </div>
            </li>        
        </ul>
    </div>
</template>
<script>
export default {
    data(){
        return{
            pageNum:3,
            velList:[],
            timer:null
        }
    },
    mounted(){
        this.$emit('getNum',this.pageNum);
        this.getVelsInfo();
        this.timer = setInterval(()=>{
            this.getVelsInfo();
        },1000*30);
    },
    beforeDestroy(){
        clearInterval(this.timer);
        this.timer = null;
    },
    methods:{
        getVelsInfo(){
            this.$http.get('http://lgkj.chuangkegf.com/vels.php')
            .then((res)=>{
                this.velList =[];
                for(var i=0;i<res.body.length;i++){
                    this.velList.push({
                        groupid: res.body[i].groupid,
                        velid:res.body[i].velid,
                        location: res.body[i].vLocation,
                        num: res.body[i].vNum,
                        state: res.body[i].vState,
                        speed: res.body[i].vSpeed == 0?'停车':(res.body[i].vSpeed+'km/h')
                    })
                }
            })
        }
    }
}
</script>



