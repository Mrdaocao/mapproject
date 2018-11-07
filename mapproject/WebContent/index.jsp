<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
%>
<head>
<script type="text/javascript" src="js/jquery-1.9.1.min.js"></script>
<script type="text/javascript"
	src="http://api.map.baidu.com/api?v=2.0&ak=qrEA2TUpPZtfnP1tuxjcixyrjNQy2nkH"></script>
</head>
<!-- 左边 -->
<div class="leftDtree">
	<div id="myTree"></div>
</div>
<div class="main-content-con">
	<div id="allmap111" style="height: 600px; margin-top: 3px;"></div>
</div>
<script type="text/javascript">
	$(function() {
		var center_xaxis = 113.3905976114235;
		var center_yaxis = 22.941422160942435;
		function init() {
			createMap();//创建地图
			addMapControl();//向地图添加控件
			addLabel(113.3905976114235,22.941422160942435);//添加标注
			//addLabel(116.424,39.915,5);
			setMapEvent();//设置地图事件
		}
		function addLabel(a,b,i) {
			k=0.000;
			j=0.000;
			var marker=null;
			var points=[];
			for(var i=0,length=30;i<length;i++){
	            var myIcon1 = new BMap.Icon("http://api0.map.bdimg.com/images/stop_icon.png", new BMap.Size(10,10));//创建图标 
	            var point=new BMap.Point(a+k,b+j);
	            marker = new BMap.Marker(point,{icon:myIcon1}); 
	           /*  var label = new BMap.Label(""+(i+1),{offset:new BMap.Size(10,-10)});   */
		       /*  label.setStyle({  
		            color : "blue",  
		            fontSize : "15px",  
		            height : "15px",  
		            lineHeight : "15px",  
		            backgroundColor:"rgba(255, 255, 255, 0.8) none repeat scroll 0 0 !important",//设置背景色透明  
		            border:"1px solid blue"  
		        });   */
		        /* marker.setLabel(label);   */
	            map.addOverlay(marker);
	            points.push(point);
	             /* if(points.length==2){//两点一条直线
	            	var polyline = new BMap.Polyline(points, {strokeColor:"red", strokeWeight:2, strokeOpacity:1});
	            	map.addOverlay(polyline);
	            	var e=points[1];
	            	points=[e];
	            	addArrow(polyline); 
	            }  */
	            addClickHandler((b+j)+','+(a+k),marker);//这里使用了闭包
	            k=k+0.0001*Math.random();
	            j=j+0.0001;
			}
			var polyline = new BMap.Polyline(points, {strokeColor:"red", strokeWeight:2, strokeOpacity:1});
        	map.addOverlay(polyline);
		}
		
		
		function addClickHandler(content, marker) {
			marker.addEventListener(
							"click",
							function(e)//添加点击事件
							{   
							
								//alert(content);
							});
			marker.addEventListener("mouseover", function(e) {//添加mouseover事件
				//alert('abc');
				$.ajax({ //传递的参数为纬度,经度
					url:'http://api.map.baidu.com/geocoder/v2/?callback=renderReverse&location='+content+'&output=json&pois=1&ak=qrEA2TUpPZtfnP1tuxjcixyrjNQy2nkH',
					type:'get',
					dataType: 'jsonp',
					success:function(data){
						console.log(data.result);
						var viewContent='<div style="font-size: 15px;line-height:30px;width:360px;"><div>地址:<span style="color:rgb(128, 128, 128)">'+data.result.formatted_address+'</span></div><div>附近:<span style="color:rgb(128, 128, 128)">'+data.result.sematic_description+'</span><div></div>';
						openInfo(viewContent, e, marker);
						//'<div style="font-size: 14px;line-height:30px;"><div>信息:经度'+(a+k)+'纬度'+(b+j)+'</div></div>'
						
					}		
				});
			});
		}

		//打开信息窗
		function openInfo(content, e, marker) {
			var infoWindow = new BMap.InfoWindow(content); // 创建信息窗口对象 
			marker.openInfoWindow(infoWindow); //开启信息窗口
		}

		function createMap() {
			map = new BMap.Map("allmap111");
			var point = new BMap.Point(center_xaxis, center_yaxis);//定义一个中心点坐标
			map.centerAndZoom(point, 17);// 
		}
		function setMapEvent() {
			map.enableDragging();//启用地图拖拽事件，默认启用(可不写)
			map.enableScrollWheelZoom();//启用地图滚轮放大缩小
			map.enableDoubleClickZoom();//启用鼠标双击放大，默认启用(可不写)
			map.enableKeyboard();//启用键盘上下左右键移动地图
		}

		function addMapControl() {
			var ctrl_nav = new BMap.NavigationControl({
				anchor : BMAP_ANCHOR_TOP_LEFT,
				type : BMAP_NAVIGATION_CONTROL_LARGE
			});
			map.addControl(ctrl_nav);
		}
		
		init();
	});
	function mapLocation(longBaidu, latBaidu) {
		var point = new BMap.Point(longBaidu, latBaidu);//定义一个中心点坐标
		map.centerAndZoom(point, 17);
	}
</script>