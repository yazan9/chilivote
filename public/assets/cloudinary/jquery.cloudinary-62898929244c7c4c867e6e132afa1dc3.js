!function(e){"use strict";if("function"==typeof define&&define.amd)define(["jquery","jquery.ui.widget","jquery.iframe-transport","jquery.fileupload"],e);else{var t=window.jQuery;e(t),t(function(){t("input.cloudinary-fileupload[type=file]").cloudinary_fileupload()})}}(function(e){"use strict";function t(e){if(null===e||"undefined"==typeof e)return"";var t,r,n=e+"",i="",a=0;t=r=0,a=n.length;for(var o=0;a>o;o++){var l=n.charCodeAt(o),u=null;128>l?r++:u=l>127&&2048>l?String.fromCharCode(l>>6|192,63&l|128):String.fromCharCode(l>>12|224,l>>6&63|128,63&l|128),null!==u&&(r>t&&(i+=n.slice(t,r)),i+=u,t=r=o+1)}return r>t&&(i+=n.slice(t,a)),i}function r(e){e=t(e);var r="00000000 77073096 EE0E612C 990951BA 076DC419 706AF48F E963A535 9E6495A3 0EDB8832 79DCB8A4 E0D5E91E 97D2D988 09B64C2B 7EB17CBD E7B82D07 90BF1D91 1DB71064 6AB020F2 F3B97148 84BE41DE 1ADAD47D 6DDDE4EB F4D4B551 83D385C7 136C9856 646BA8C0 FD62F97A 8A65C9EC 14015C4F 63066CD9 FA0F3D63 8D080DF5 3B6E20C8 4C69105E D56041E4 A2677172 3C03E4D1 4B04D447 D20D85FD A50AB56B 35B5A8FA 42B2986C DBBBC9D6 ACBCF940 32D86CE3 45DF5C75 DCD60DCF ABD13D59 26D930AC 51DE003A C8D75180 BFD06116 21B4F4B5 56B3C423 CFBA9599 B8BDA50F 2802B89E 5F058808 C60CD9B2 B10BE924 2F6F7C87 58684C11 C1611DAB B6662D3D 76DC4190 01DB7106 98D220BC EFD5102A 71B18589 06B6B51F 9FBFE4A5 E8B8D433 7807C9A2 0F00F934 9609A88E E10E9818 7F6A0DBB 086D3D2D 91646C97 E6635C01 6B6B51F4 1C6C6162 856530D8 F262004E 6C0695ED 1B01A57B 8208F4C1 F50FC457 65B0D9C6 12B7E950 8BBEB8EA FCB9887C 62DD1DDF 15DA2D49 8CD37CF3 FBD44C65 4DB26158 3AB551CE A3BC0074 D4BB30E2 4ADFA541 3DD895D7 A4D1C46D D3D6F4FB 4369E96A 346ED9FC AD678846 DA60B8D0 44042D73 33031DE5 AA0A4C5F DD0D7CC9 5005713C 270241AA BE0B1010 C90C2086 5768B525 206F85B3 B966D409 CE61E49F 5EDEF90E 29D9C998 B0D09822 C7D7A8B4 59B33D17 2EB40D81 B7BD5C3B C0BA6CAD EDB88320 9ABFB3B6 03B6E20C 74B1D29A EAD54739 9DD277AF 04DB2615 73DC1683 E3630B12 94643B84 0D6D6A3E 7A6A5AA8 E40ECF0B 9309FF9D 0A00AE27 7D079EB1 F00F9344 8708A3D2 1E01F268 6906C2FE F762575D 806567CB 196C3671 6E6B06E7 FED41B76 89D32BE0 10DA7A5A 67DD4ACC F9B9DF6F 8EBEEFF9 17B7BE43 60B08ED5 D6D6A3E8 A1D1937E 38D8C2C4 4FDFF252 D1BB67F1 A6BC5767 3FB506DD 48B2364B D80D2BDA AF0A1B4C 36034AF6 41047A60 DF60EFC3 A867DF55 316E8EEF 4669BE79 CB61B38C BC66831A 256FD2A0 5268E236 CC0C7795 BB0B4703 220216B9 5505262F C5BA3BBE B2BD0B28 2BB45A92 5CB36A04 C2D7FFA7 B5D0CF31 2CD99E8B 5BDEAE1D 9B64C2B0 EC63F226 756AA39C 026D930A 9C0906A9 EB0E363F 72076785 05005713 95BF4A82 E2B87A14 7BB12BAE 0CB61B38 92D28E9B E5D5BE0D 7CDCEFB7 0BDBDF21 86D3D2D4 F1D4E242 68DDB3F8 1FDA836E 81BE16CD F6B9265B 6FB077E1 18B74777 88085AE6 FF0F6A70 66063BCA 11010B5C 8F659EFF F862AE69 616BFFD3 166CCF45 A00AE278 D70DD2EE 4E048354 3903B3C2 A7672661 D06016F7 4969474D 3E6E77DB AED16A4A D9D65ADC 40DF0B66 37D83BF0 A9BCAE53 DEBB9EC5 47B2CF7F 30B5FFE9 BDBDF21C CABAC28A 53B39330 24B4A3A6 BAD03605 CDD70693 54DE5729 23D967BF B3667A2E C4614AB8 5D681B02 2A6F2B94 B40BBE37 C30C8EA1 5A05DF1B 2D02EF8D",n=0,i=0,a=0;n=-1^n;for(var o=0,l=e.length;l>o;o++)a=255&(n^e.charCodeAt(o)),i="0x"+r.substr(9*a,8),n=n>>>8^i;return n=-1^n,0>n&&(n+=4294967296),n}function n(e,t,r){var n=e[t];return delete e[t],"undefined"==typeof n?r:n}function i(t){return t?e.isArray(t)?t:[t]:[]}function a(e){return"undefined"!=typeof e&&(""+e).length>0}function o(t){var r=t.width,l=t.height,u=n(t,"size");if(u){var c=u.split("x");t.width=r=c[0],t.height=l=c[1]}var d=t.overlay||t.underlay,D=n(t,"crop"),f=i(n(t,"angle")).join("."),B=d||a(f)||"fit"==D||"limit"==D||"lfill"==D;r&&(B||parseFloat(r)<1)&&delete t.width,l&&(B||parseFloat(l)<1)&&delete t.height,D||d||(r=l=void 0);var s=n(t,"background");s=s&&s.replace(/^#/,"rgb:");var p=n(t,"color");p=p&&p.replace(/^#/,"rgb:");var A=i(n(t,"transformation",[])),C=[];e.grep(A,function(e){return"object"==typeof e}).length>0?A=e.map(A,function(t){return o("object"==typeof t?e.extend({},t):{transformation:t})}):(C=e.grep(A,function(e){return e}).join("."),A=[]);var F=n(t,"effect");e.isArray(F)&&(F=F.join(":"));var E=n(t,"border");if(e.isPlainObject(E)){var h=""+(E.width||2),g=(E.color||"black").replace(/^#/,"rgb:");E=h+"px_solid_"+g}var y=i(n(t,"flags")).join("."),m=[["c",D],["t",C],["w",r],["h",l],["b",s],["co",p],["e",F],["a",f],["bo",E],["fl",y]],v={x:"x",y:"y",radius:"r",gravity:"g",quality:"q",prefix:"p",default_image:"d",underlay:"u",overlay:"l",fetch_format:"f",density:"dn",page:"pg",color_space:"cl",delay:"dl",opacity:"o"};for(var _ in v)m.push([v[_],n(t,_)]);m.sort(function(e,t){return e[0]<t[0]?-1:e[0]>t[0]?1:0}),m.push([n(t,"raw_transformation")]);var b=e.map(e.grep(m,function(e){var t=e[e.length-1];return a(t)}),function(e){return e.join("_")}).join(",");return A.push(b),e.grep(A,a).join("/")}function l(e){if(!e.match(/^https?:\//)){var t=document.location.protocol+"//"+document.location.host;"?"==e[0]?t+=document.location.pathname:"/"!=e[0]&&(t+=document.location.pathname.replace(/\/[^\/]*$/,"/")),e=t+e}return e}function u(t,i){i=i||{};var u=n(i,"type","upload");"fetch"==u&&(i.fetch_format=i.fetch_format||n(i,"format"));var c=o(i),d=n(i,"resource_type","image"),f=n(i,"version"),s=n(i,"format"),p=n(i,"cloud_name",e.cloudinary.config().cloud_name);if(!p)throw"Unknown cloud_name";var A=n(i,"private_cdn",e.cloudinary.config().private_cdn),C=n(i,"secure_distribution",e.cloudinary.config().secure_distribution),F=n(i,"cname",e.cloudinary.config().cname),E=n(i,"cdn_subdomain",e.cloudinary.config().cdn_subdomain),h=n(i,"shorten",e.cloudinary.config().shorten),g=n(i,"secure","https:"==window.location.protocol),y=n(i,"protocol",e.cloudinary.config().protocol),m=n(i,"trust_public_id");if("fetch"==u&&(t=l(t)),t.match(/^https?:/)){if("upload"==u||"asset"==u)return t;t=encodeURIComponent(t).replace(/%3A/g,":").replace(/%2F/g,"/")}else t=encodeURIComponent(decodeURIComponent(t)).replace(/%3A/g,":").replace(/%2F/g,"/"),s&&(m||(t=t.replace(/\.(jpg|png|gif|webp)$/,"")),t=t+"."+s);var v=g?"https://":window.location.protocol+"//";if(v=y?y+"//":v,p.match(/^\//)&&!g)v="/res"+p;else{var _=!A;if(g)C&&C!=D||(C=A?p+"-res.cloudinary.com":B),_=_||C==B,v+=C;else{var b=E?"a"+(r(t)%5+1)+".":"",w=F||(A?p+"-res.cloudinary.com":"res.cloudinary.com");v+=b+w}_&&(v+="/"+p)}h&&"image"==d&&"upload"==u&&(d="iu",u=void 0),t.search("/")>=0&&!t.match(/^v[0-9]+/)&&!t.match(/^https?:\//)&&!a(f)&&(f=1);var j=[v,d,u,c,f?"v"+f:"",t].join("/").replace(/([^:])\/+/g,"$1/");return j}function c(e){var t=n(e,"html_width"),r=n(e,"html_height");t&&(e.width=t),r&&(e.height=r)}var d="d3jpl91pxevbkh.cloudfront.net",D="cloudinary-a.akamaihd.net",f="res.cloudinary.com",B=f,s=null;e.cloudinary={CF_SHARED_CDN:d,OLD_AKAMAI_SHARED_CDN:D,AKAMAI_SHARED_CDN:f,SHARED_CDN:B,config:function(t,r){if(s||(s={},e('meta[name^="cloudinary_"]').each(function(){s[e(this).attr("name").replace("cloudinary_","")]=e(this).attr("content")})),"undefined"!=typeof r)s[t]=r;else{if("string"==typeof t)return s[t];t&&(s=t)}return s},url:function(t,r){return r=e.extend({},r),u(t,r)},url_internal:u,transformation_string:function(t){return t=e.extend({},t),o(t)},image:function(t,r){r=e.extend({},r);var n=u(t,r);return c(r),e("<img/>").attr(r).attr("src",n)},facebook_profile_image:function(t,r){return e.cloudinary.image(t,e.extend({type:"facebook"},r))},twitter_profile_image:function(t,r){return e.cloudinary.image(t,e.extend({type:"twitter"},r))},twitter_name_profile_image:function(t,r){return e.cloudinary.image(t,e.extend({type:"twitter_name"},r))},gravatar_image:function(t,r){return e.cloudinary.image(t,e.extend({type:"gravatar"},r))},fetch_image:function(t,r){return e.cloudinary.image(t,e.extend({type:"fetch"},r))},sprite_css:function(t,r){return r=e.extend({type:"sprite"},r),t.match(/.css$/)||(r.format="css"),e.cloudinary.url(t,r)}},e.fn.cloudinary=function(t){return this.filter("img").each(function(){var r=e.extend({width:e(this).attr("width"),height:e(this).attr("height"),src:e(this).attr("src")},e.extend(e(this).data(),t)),i=n(r,"source",n(r,"src")),a=u(i,r);c(r),e(this).attr({src:a,width:r.width,height:r.height})}),this};var p=null;e.fn.webpify=function(t,r){var n=this;if(t=t||{},r=r||t,!p){p=e.Deferred();var i=new Image;i.onerror=p.reject,i.onload=p.resolve,i.src="data:image/webp;base64,UklGRi4AAABXRUJQVlA4TCEAAAAvAUAAEB8wAiMwAgSSNtse/cXjxyCCmrYNWPwmHRH9jwMA"}e(function(){p.done(function(){e(n).cloudinary(e.extend({},e.extend(r,{format:"webp"})))}).fail(function(){e(n).cloudinary(t)})})},e.fn.fetchify=function(t){return this.cloudinary(e.extend(t,{type:"fetch"}))},e.fn.fileupload&&(e.fn.cloudinary_fileupload=function(t){var r=!this.data("blueimpFileupload");if(r&&(t=e.extend({maxFileSize:2e7,dataType:"json",headers:{"X-Requested-With":"XMLHttpRequest"}},t)),this.fileupload(t),r&&(this.bind("fileuploaddone",function(t,r){if(!r.result.error){if(r.result.path=["v",r.result.version,"/",r.result.public_id,r.result.format?"."+r.result.format:""].join(""),r.cloudinaryField&&r.form.length>0){var n=[r.result.resource_type,r.result.type,r.result.path].join("/")+"#"+r.result.signature,i=e(t.target).prop("multiple"),a=function(){e("<input></input>").attr({type:"hidden",name:r.cloudinaryField}).val(n).appendTo(r.form)};if(i)a();else{var o=e(r.form).find('input[name="'+r.cloudinaryField+'"]');o.length>0?o.val(n):a()}}e(t.target).trigger("cloudinarydone",r)}}),this.bind("fileuploadstart",function(t){e(t.target).trigger("cloudinarystart")}),this.bind("fileuploadstop",function(t){e(t.target).trigger("cloudinarystop")}),this.bind("fileuploadprogress",function(t,r){e(t.target).trigger("cloudinaryprogress",r)}),this.bind("fileuploadprogressall",function(t,r){e(t.target).trigger("cloudinaryprogressall",r)}),this.bind("fileuploadfail",function(t,r){e(t.target).trigger("cloudinaryfail",r)}),this.bind("fileuploadalways",function(t,r){e(t.target).trigger("cloudinaryalways",r)}),!this.fileupload("option").url)){var n="https://api.cloudinary.com/v1_1/"+e.cloudinary.config().cloud_name+"/upload";this.fileupload("option","url",n)}return this},e.fn.cloudinary_upload_url=function(e){this.fileupload("option","formData").file=e,this.fileupload("add",{files:[e]}),delete this.fileupload("option","formData").file},e.cloudinary.unsigned_upload_tag=function(t,r,n){n=n||{},r=e.extend({},r)||{};for(var i in r){var a=r[i];e.isPlainObject(a)?r[i]=e.map(a,function(){return arguments.join("=")}).join("|"):e.isArray(a)&&(r[i]=a.length>0&&e.isArray(a[0])?e.map(a,function(e){return e.join(",")}).join("|"):a.join(","))}r.callback||(r.callback="/cloudinary_cors.html"),r.upload_preset=t,n.formData=r,n.cloudinary_field&&(n.cloudinaryField=n.cloudinary_field,delete n.cloudinary_field);var o=n.html||{};o["class"]="cloudinary_fileupload "+(o["class"]||"");var l=e("<input/>").attr({type:"file",name:"file"}).attr(o).cloudinary_fileupload(n);return l})});