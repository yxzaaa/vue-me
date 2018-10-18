<template>
    <!--车辆到达编辑-->
    <div class='car-arr-box'>
        <div class='toast-box' :class='{show:!showToast.isShow}'>
            {{showToast.toastText}}
        </div>
        <div class='curr-msg'>
            <div class='curr-msg-title'><span class='icon-exclamation-sign'></span>当前提示词 (例)<span class='icon-cogs edit' @click='openEdit()'></span></div>
            <div class='curr-msg-content'>
                <div class='icon-quote-left'></div>
                {{noteMsg}}
                <div class=' icon-quote-right'></div>
            </div>
        </div>
        <div class='edit-box' v-if='editActive'>
            <div class='edit-field'>
                <input type="text" v-model="editMsg" placeholder="请输入自定义车辆到达提示语">
            </div>
            <div class='edit-confirm' @click='confirmEdit()'><span class='icon-ok'></span></div>
            <div class='edit-cancel' @click='cancelEdit()'><span class='icon-remove'></span></div>
        </div>
    </div>
</template>
<script>
export default {
    props:['Gid'],
    data(){
        return{
            pageNum:11,
            noteTitle:'车辆到达',
            currGroup:this.Gid,
            noteMsg:'',
            editActive:false,
            editMsg:'',
            showToast:{
                isShow:false,
                toastText:'',
                duration:2000
            }
        }
    },
    mounted(){
        this.$emit('getPageNum',this.pageNum);
        this.$http.post('http://lgkj.chuangkegf.com/notice.php',
        {kind:'select',title:this.noteTitle},{emulateJSON:true}).then((res)=>{
            this.noteMsg = res.body[0].msg;
        },(err)=>{
            console.log(err);
        })
    },
    watch:{
        Gid:{  
            handler:function(val,oldval){  
                // console.log(val);  
            },  
            deep:true//对象内部的属性监听，也叫深度监听  
        }
    },
    methods:{
        confirmEdit(){
            if(this.editMsg != ''){
                this.$http.post('http://lgkj.chuangkegf.com/notice.php',
                {kind:'update',title:this.noteTitle,msg:this.editMsg},{emulateJSON:true}).then((res)=>{
                    this.noteMsg = this.editMsg;
                    this.editMsg = '';
                    this.editActive = false;
                    this.showToast.isShow = true;
                    this.showToast.toastText = '修改成功！';
                    setTimeout(()=>{
                        this.showToast.isShow = false;
                    },this.showToast.duration)
                },(err)=>{
                    console.log(err);
                })
            }
        },
        cancelEdit(){
            this.editActive = false;
        },
        openEdit(){
            this.editActive = true;
        }
    }
}
</script>

