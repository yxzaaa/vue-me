<template>
    <!--分组管理页面-->
    <div class='group-box'>
        <div class='edit-point-content' v-if='pointEdit'>
            <div class='edit-title'>编辑节点</div>
            <ul class="edit-point-box">
                <li>
                    <span>负责人</span>
                    <input type="text" v-model='editPointInfo.leader'>
                </li>
                <li>
                    <span>电话</span>
                    <input type="text" v-model='editPointInfo.phone'>
                </li>
                <li>
                    <span>车辆</span>
                    <input type="text" v-model='editPointInfo.vel'>
                </li>
                <li>
                    <span>纬度</span>
                    <input type="text" v-model='editPointInfo.lat'>
                </li>
                <li>
                    <span>经度</span>
                    <input type="text" v-model='editPointInfo.lon'>
                </li>
                <li>
                    <span>地址</span>
                    <input type="text" v-model='editPointInfo.addr'>
                </li>
                <li>
                    <span class='point-btn-confirm icon-ok' @click='confirmPointAdd()' v-if='isAdd'></span>
                    <span class='point-btn-confirm icon-ok' @click='confirmPointEdit()' v-if='!isAdd'></span>
                    <span class='point-btn-cancel icon-remove' @click='cancelPointEdit()'></span>
                </li>
            </ul>
        </div>
        <ul class='group-list'>
            <li v-for='(item,index) in groups' :key='index'>
                <div class='group-title-info' :class='{titleHide:item.titleEditing}'>
                    <span class='group-name'>{{item.name}}</span>
                </div>
                <div class='group-pointer'>
                    <ul>
                        <li style='width:10%'>序号</li>
                        <li style='width:15%'>负责人</li>
                        <li style='width:15%'>电话</li>
                        <li style='width:15%'>车辆</li>
                        <li style='width:10%'>纬度</li>
                        <li style='width:10%'>经度</li>
                        <li style='width:25%'>地址</li>
                        <li style='width:15%;min-width:80px;'>操作</li>
                    </ul>
                    <ul>
                        <li v-for='(item,index1) in item.pointMsg' :key='index1'>
                            <span style='width:10%'>{{index1+1}}</span>
                            <span style='width:15%'>{{item.leader}}</span>
                            <span style='width:15%'>{{item.phone}}</span>
                            <span style='width:15%'>{{item.vel}}</span>
                            <span style='width:10%'>{{item.lat}}</span>
                            <span style='width:10%'>{{item.lon}}</span>
                            <span style='width:25%'>{{item.addr}}</span>
                            <span style='width:15%;min-width:80px;'>
                                <span class='icon-cog point-edit' @click='editPoint(index,index1)'></span>
                                <span class='icon-remove-sign remove-point' @click='removePoint(index,index1)'></span>
                            </span>
                        </li>
                        <li class='add-point'>
                            <span @click='addPoint(index)' class='icon-plus'></span>
                        </li>  
                    </ul>
                </div>
                <div class='group-pointer-line'>
                    <ul>
                        <li style='width:20%'>负责人</li>
                        <li style='width:30%'>电话</li>
                        <li style='width:30%'>地址</li>
                        <li style='width:20%;min-width:80px;'>操作</li>
                    </ul>
                    <ul>
                        <li v-for='(item,index1) in item.pointMsg' :key='index1'>
                            <span style='width:20%'>{{item.leader}}</span>
                            <span style='width:30%'>{{item.phone}}</span>
                            <span style='width:30%'>{{item.addr}}</span>
                            <span style='width:20%;min-width:80px;'>
                                <span class='icon-cog point-edit' @click='editPoint(index,index1)'></span>
                                <span class='icon-remove-sign remove-point' @click='removePoint(index,index1)'></span>
                            </span>
                        </li>
                        <li class='add-point'>
                            <span @click='addPoint(index)' class='icon-plus'></span>
                        </li>  
                    </ul>
                </div>
            </li>
        </ul>
    </div>
</template>
<script>
export default {
    data(){
        return {
            pageNum:2,
            isInit:true,
            pointEdit:false,
            editPointInfo:{
                groupIndex:0,
                pointIndex:0,
                groupid:0,
                pid:0,
                leader:'',
                phone:'',
                vel:'',
                lat:'',
                lon:'',
                addr:''
            },
            groups:[],
        }
    },
    mounted(){
        this.$emit('getNum',this.pageNum);
        this.$http.post('http://lgkj.chuangkegf.com/groups.php',
        {kind:'select'},{emulateJSON:true}).then((res)=>{
            for(var i=0;i<res.body.length;i++){
                this.groups.push({
                    name:res.body[i].gname,
                    // leader:res.body[i].leader,
                    groupid:res.body[i].groupid,
                    titleEditing:false,
                    currGroupName:'',
                    currLeader:'',
                    pointMsg:[]
                })
            }
            this.$http.post('http://lgkj.chuangkegf.com/points.php',
            {kind:'select'},{emulateJSON:true}).then((res)=>{
                var data = res.body;
                for(var i=0;i<data.length;i++){
                    for(var j=0;j<this.groups.length;j++){
                        if(this.groups[j].groupid == data[i].groupid){
                            this.groups[j].pointMsg.push(data[i]);
                        }
                    }
                }
            },(err)=>{
                console.log(err);
            })
        },(err)=>{
            console.log(err);
        })
    },
    methods:{
        editPoint(index,index1){
            this.isAdd = false;
            this.editPointInfo = {
                groupIndex:index,
                pointIndex:index1,
                groupid:this.groups[index].groupid,
                pid:this.groups[index].pointMsg[index1].pid,
                leader:this.groups[index].pointMsg[index1].leader,
                phone:this.groups[index].pointMsg[index1].phone,
                vel:this.groups[index].pointMsg[index1].vel,
                lat:this.groups[index].pointMsg[index1].lat,
                lon:this.groups[index].pointMsg[index1].lon,
                addr:this.groups[index].pointMsg[index1].addr
            }
            this.pointEdit = true;
        },
        addPoint(index){
            this.isAdd = true;
            this.editPointInfo.groupIndex = index;
            this.editPointInfo.pointIndex = this.groups[index].pointMsg.length;
            this.editPointInfo.groupid = this.groups[index].groupid;
            this.pointEdit = true;
        },
        confirmPointEdit(){
            if(confirm('确认修改节点信息？') 
            && this.editPointInfo.leader != '' 
            && this.editPointInfo.long != '' 
            && this.editPointInfo.phone != '' 
            && this.editPointInfo.vel != '' 
            && this.editPointInfo.lat != '' 
            && this.editPointInfo.addr != '' ){
                console.log(this.editPointInfo);
                this.$http.post('http://lgkj.chuangkegf.com/points.php',
                {
                    kind:'update',
                    pid:this.editPointInfo.pid,
                    leader:this.editPointInfo.leader,
                    phone:this.editPointInfo.phone,
                    vel:this.editPointInfo.vel,
                    lat:this.editPointInfo.lat,
                    lon:this.editPointInfo.lon,
                    addr:this.editPointInfo.addr
                },{emulateJSON:true}).then((res)=>{
                    var index = this.editPointInfo.groupIndex;
                    var index1 = this.editPointInfo.pointIndex;
                    if(res.body.code == 200){
                        this.groups[index].pointMsg[index1].leader = this.editPointInfo.leader;
                        this.groups[index].pointMsg[index1].phone = this.editPointInfo.phone;
                        this.groups[index].pointMsg[index1].vel = this.editPointInfo.vel;
                        this.groups[index].pointMsg[index1].lat = this.editPointInfo.lat;
                        this.groups[index].pointMsg[index1].lon = this.editPointInfo.lon;
                        this.groups[index].pointMsg[index1].addr = this.editPointInfo.addr;
                    }
                },(err)=>{
                    console.log(err);
                })
            }
            this.pointEdit = false;
        },
        confirmPointAdd(){
            if(confirm('确认新建节点？') 
            && this.editPointInfo.leader != '' 
            && this.editPointInfo.lon != '' 
            && this.editPointInfo.phone != '' 
            && this.editPointInfo.vel != '' 
            && this.editPointInfo.lat != '' 
            && this.editPointInfo.addr != '' )
            {
                var index = this.editPointInfo.groupIndex;
                this.$http.post('http://lgkj.chuangkegf.com/points.php',
                {
                    kind:'insert',
                    groupid:this.editPointInfo.groupid,
                    leader:this.editPointInfo.leader,
                    phone:this.editPointInfo.phone,
                    vel:this.editPointInfo.vel,
                    lat:this.editPointInfo.lat,
                    lon:this.editPointInfo.lon,
                    addr:this.editPointInfo.addr
                },{emulateJSON:true}).then((res)=>{
                    var index1 = this.editPointInfo.pointIndex;
                    if(res.body.code == 200){
                        this.groups[index].pointMsg.push({
                            id:index1+1,
                            pid:res.body.pid[0],
                            leader:this.editPointInfo.leader,
                            phone:this.editPointInfo.phone,
                            vel:this.editPointInfo.vel,
                            lat:this.editPointInfo.lat,
                            lon:this.editPointInfo.lon,
                            addr:this.editPointInfo.addr
                        });
                    }
                },(err)=>{
                    console.log(err);
                })
            }
            this.pointEdit = false;
        },
        cancelPointEdit(){
            this.pointEdit = false;
        },
        removePoint(index,index1){
            if(confirm('确认删除节点信息？')){
                this.$http.post('http://lgkj.chuangkegf.com/points.php',
                {
                    kind:'delete',
                    pid:this.groups[index].pointMsg[index1].pid
                },{emulateJSON:true}).then((res)=>{
                    if(res.body.code == 200){
                        this.groups[index].pointMsg.splice(index1,1); 
                    }
                },(err)=>{
                    console.log(err);
                })
            }
        }
    }
}
</script>
