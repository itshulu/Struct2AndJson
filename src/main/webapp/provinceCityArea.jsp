<%--
  Created by IntelliJ IDEA.
  User: 舒露
  Date: 2018/10/9
  Time: 13:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page isELIgnored="false" %>
<% String path = request.getContextPath();
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    application.setAttribute("basePath", basePath);
%>
<html>
<head>
    <title>省份-城市-区域 三级联动 Struct2AndJson</title>
    <script type="text/javascript" src="ajax.js"></script>
</head>
<body>
<select id="provinceID" style="width: 111px">
    <option>选择省份</option>
    <option>湖南</option>
    <option>湖北</option>
    <option>广东</option>
    <option>广西</option>
</select>

<select id="cityID" style="width: 111px">
    <option>选择城市</option>
</select>

<select id="areaID" style="width: 111px">
    <option>选择区域</option>
</select>

<script>
    document.getElementById("provinceID").onchange = function () {
        //清空城市下拉框
        var cityElement = document.getElementById("cityID");
        cityElement.options.length = 1;
        var province = this[this.selectedIndex].innerHTML;
        if ("选择省份" !== province) {
            var ajax = createAJAX();
            var method = "POST";
            var url = "${basePath}/ProvinceCityAreaAction?time=" + new Date().getTime();
            ajax.open(method, url);
            ajax.setRequestHeader("content-type", "application/x-www-form-urlencoded");
            var content = "bean.province=" + province;
            ajax.send(content);//将请求信息组成请求字符串
            ajax.onreadystatechange = function () {
                if (ajax.readyState === 4) {
                    if (ajax.status === 200) {
                        var jsonJava = ajax.responseText;
                        var jsonJs = eval("(" + jsonJava + ")");
                        var array = jsonJs.cityList;
                        var size = array.length;
                        for (var i = 0; i < size; i++) {
                            var city = array[i];
                            var option = document.createElement("option");
                            option.innerHTML = city;
                            cityElement.appendChild(option);
                        }
                    }
                }
            }
        }
    }
</script>
<script type="text/javascript">
    document.getElementById("cityID").onchange = function () {
        var areaElement = document.getElementById("areaID");
        areaElement.options.length = 1;
        var city = this[this.selectedIndex].innerHTML;
        if ("选择城市" != city) {
            //NO1)
            var ajax = createAJAX();
            //NO2)
            var method = "POST";
            var url = "${basePath}/findAreaByCity?time=" + new Date().getTime();
            ajax.open(method, url);
            //NO3)
            ajax.setRequestHeader("content-type", "application/x-www-form-urlencoded")
            //NO4)
            var content = "bean.city=" + city;
            ajax.send(content);

            //------------------------------------------等待

            //NO5)
            ajax.onreadystatechange = function () {

                if (ajax.readyState == 4) {
                    if (ajax.status == 200) {
                        //NO6)
                        var jsonJAVA = ajax.responseText;
                        var jsonJS = eval("(" + jsonJAVA + ")");
                        var array = jsonJS.areaList;
                        var size = array.length;
                        for (var i = 0; i < size; i++) {
                            var area = array[i];
                            var option = document.createElement("option");
                            option.innerHTML = area;
                            areaElement.appendChild(option);
                        }
                    }
                }
            }

        }
    }
</script>

</body>
</html>
