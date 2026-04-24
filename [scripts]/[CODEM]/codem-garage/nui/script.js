window.addEventListener("message", function (event) {
    var item = event.data;
    switch (item.action) {
        case "OPEN_MENU":
            app.show = true;
            app.car(item.vehicles),
            
            app.setDefault()
            app.GarageType(item.type)
        break;
        case "send_response":
            app.GetResponse(item.resourceName)
            app.Weight(item.weight)
            app.Text(item.text)
            app.Sell(item.sell)
            app.Transfer(item.transfer)
            app.Reapir(item.repair)
            app.Image(item.image)
            app.CarLogo(item.logo)
            app.setVale(item.vale)
            app.setImpound(item.impound)
            app.setImpoundPrice(item.impoundprice)
        case "SET_PROFILE":
            app.playername(item.name)
            app.PlayerImage(item.avatar)
        break;
    }
});

const app = new Vue({
    el: "#app",

    data: {
        show: false,
        name: '',
        vehicles: '',
        lastplate: '',
        stored: null,
        carname: null,
        weight: '',
        text: '',
        cartext: null,
        carweight: null,
        carmark: null,
        speed: null,
        repair: false,
        model: null,
        plate: null,
        caracce: null,
        garage: null,
        showsell: false,
        sell: false,
        transfer: false,
        transfershows: false,
        showspecs: true,
        price: null,
        showmotor : false,
        showcar: false,
        showbike: false,
        showfavorite: false,
        image: null,
        garagetypes: null,
        move: false,
        logo: null,
        vale : false,
        impound: false,
        accesable: true,
        showairs: false,
        showboats: false,
        border: [],
        lastindex: null,
        avatar: './images/defaultimage.png',
        comp: false,
        extracount: 1,
        impoundprice: 1000,
        liverycount: 1,
    },


    mounted() {
        let holding = false;
        
        document.addEventListener("mousedown", function(e) {
            holding = true;
        });
        document.addEventListener("mouseup", function(e) {
            holding = false;
        });
    
        var direction = "",
        oldx = 0,
        mousemovemethod = function(e) {
            if (e.pageX < oldx) {
                direction = "left";
            } else if (e.pageX > oldx) {
                direction = "right";
            }
            oldx = e.pageX;
            if (direction == "left" && holding) {
                if (e.target.classList.contains("mouse-move")) {
                    $.post(`https://${GetParentResourceName()}/rotateleft`);
                }
            }
            if (direction == "right" && holding) {
                if (e.target.classList.contains("mouse-move")) {
                    $.post(`https://${GetParentResourceName()}/rotateright`);
                }
            }
        };
        document.addEventListener("mousemove", mousemovemethod);

        document.addEventListener('wheel',function(event){
            if (event.target.classList.contains("mouse-move")) {
                if(event.wheelDelta < 0){
                    $.post(`https://${GetParentResourceName()}/zoomout`)
                } else if(event.wheelDelta > 0) {
                    $.post(`https://${GetParentResourceName()}/zoomin`)
                }
            }
        });
        
        const element = document.querySelector(".car-wrapper");
        element.addEventListener('wheel', (event) => {
            event.preventDefault();
            element.scrollBy({
                left: event.deltaY < 0 ? -30 : 30,
 
            });
        });

        const element2 = document.querySelector(".car-wrapper2");
        element2.addEventListener('wheel', (event) => {
            event.preventDefault();
            element2.scrollBy({
                left: event.deltaY < 0 ? -30 : 30,
 
            });
        });

        const element3 = document.querySelector(".car-wrapper3");
        element3.addEventListener('wheel', (event) => {
            event.preventDefault();
            element3.scrollBy({
                left: event.deltaY < 0 ? -30 : 30,
 
            });
        });

        const element4 = document.querySelector(".car-wrapper4");
        element4.addEventListener('wheel', (event) => {
            event.preventDefault();
            element4.scrollBy({
                left: event.deltaY < 0 ? -30 : 30,
 
            });
        });

        const element5 = document.querySelector(".car-wrapper5");
        element5.addEventListener('wheel', (event) => {
            event.preventDefault();
            element5.scrollBy({
                left: event.deltaY < 0 ? -30 : 30,
 
            });
        });

    },

    methods: {
        playername (name) {
            this.name = name
        },

        setVale (vale) {
            this.vale = vale
        },

        setImpoundPrice(impoundprice) {
            this.impoundprice = impoundprice
        },

        setImpound (impound) {
            this.impound = impound
        },

        setDefault(){
            this.lastplate = ''
            this.stored = null
            this.carname = null
            this.carweight = null
            this.cartext = null
            this.carmark = null
            this.speed = null
            this.model = null
            this.garage = null
            this.model = null
            this.caracce = null
            this.transfershows = false
            this.showspecs = true
            this.transfershows = false
            this.showsell = false
            this.price = null
            this.showcar = true
            this.showmotor = false
            this.showbike = false
            this.showfavorite = false
            this.garagetypes = null
            this.showairs = false
            this.lastindex = null
            this.border = []
            this.plate = null
            this.comp = false
            this.extracount = 1
            this.liverycount = 1
        },

        Reapir (repair) {
            this.repair = repair
        },

        CarLogo (logo) {
            this.logo = logo
        },

        Weight (weight) {
            this.weight = weight
        },

        Image (image) {
            this.image = image
        },

        Text (text) {
            this.text = text
        },

        GarageType(type) {
            this.garagetypes = type
            if (type == "aircraft"){
                this.showairs = true
            }
            if (type == "boat"){
                this.showboats = true
            }
        },

        Sell (sell) {
            this.sell = sell
        },

        Transfer (transfer) {
            this.transfer = transfer
        },

        PlayerImage (val) {
            if(val != undefined && val != false){
                this.avatar = val
            }
        },

        favorite(plate,bool) {
            if(this.plate == plate) {
                if(this.carweight) {
                    this.accesable = false
                    $.post(`https://${GetParentResourceName()}/favorite`, JSON.stringify({
                        plate: plate,
                        bool: bool,
                    }),(data) => {
                        if(data) {
                            this.accesable = true
                        }
                    });

                    this.show = false;
                    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
                }
            }else{
                console.log("Don't forget to select the vehicle")
            }
        },

        spawnlocalvehicle (model,garage,stored,carname,vehicleclass,carlogo,speed,acce,price,index) {
            if (this.accesable) {
                this.lastplate = ''
                this.border[index] = true
                this.border[this.lastindex] = false
    
                if ( !checkFileExist('./images/logo/'+carlogo+'.png')) {
                    this.carmark = 'noimage';
                } else {
                    this.carmark = carlogo;
                }
                this.stored    = stored
                this.carname   = carname
                this.class     = vehicleclass
                this.cartext   = this.text[vehicleclass]
                this.carweight = this.weight[vehicleclass]
                this.carlogo   = carlogo
                this.speed     = speed
                this.model     = model
                this.garage    = garage
                this.plate     = model['plate']
                this.caracce   = acce.toFixed(2)
                this.price     = price
                this.lastindex = index
                setTimeout(() => {
                    if(this.plate != this.lastplate && this.plate != undefined){
                        $.post(`https://${GetParentResourceName()}/spawnlocalvehicle`, JSON.stringify({
                            model: model,
                            garage: garage,
                        }),(data) => {
                            if(data) {
                                this.lastplate = data
                            }
                        });
                    }
                }, 300);
            }
        },

        showfavorites () {
            if(this.showfavorite == true){
                this.showfavorite = false
            }else {
                this.showfavorite = true
            }
        },

        showcomp(){
          this.comp = true
          this.showspecs = false
        },

        car(vehicles) {
            for (var i = 0; i < vehicles.length; i++) {
                if ( !checkFileExist('./images/cars/'+vehicles[i].carname+'.png')) {
                   vehicles[i].carimage = 'noimage';
                } else {
                    vehicles[i].carimage = vehicles[i].carname;
                }
                
                if (this.image[vehicles[i].carname] != undefined) {
                    vehicles[i].carimage = this.image[vehicles[i].carname];
                }


                if ( !checkFileExist('./images/logo/'+vehicles[i].carlogo+'.png')) {
                    vehicles[i].carlogo = 'unmarked';
                } else {
                    vehicles[i].carlogo = vehicles[i].carlogo;
                }

                if (this.logo[vehicles[i].carname] != undefined) {
                    vehicles[i].carlogo = this.logo[vehicles[i].carname];
                }
            }
            this.vehicles = vehicles
        },



        GetResponse(resourceName) {
            this.resourceName = resourceName
            $.post(`https://${GetParentResourceName()}/GetResponse`, JSON.stringify({}));
        },

        transfervehicle(data){
            var id = $("#identifier").val();
            $.post(`https://${GetParentResourceName()}/transfervehicle`, JSON.stringify({
                plate: this.plate,
                id: id,
            }));
            this.show = false;
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        },

        repairvehicle(data){
            $.post(`https://${GetParentResourceName()}/repair`, JSON.stringify({
                plate: this.plate
            }));
        },

        sellVehicle(data){
            $.post(`https://${GetParentResourceName()}/sellvehicle`, JSON.stringify({
                plate: this.plate,
                price: this.price,
            }));
            this.show = false;
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        },

        nextextra(){
            if(this.extracount <= 13){
                this.extracount += 1;
                $.post(`https://${GetParentResourceName()}/extra`, JSON.stringify({
                    count: this.extracount,
                }));
                this.extracount = this.extracount;
            }
        },

        backextra(){
            if(this.extracount >= 1){
                this.extracount -= 1;
                $.post(`https://${GetParentResourceName()}/extra`, JSON.stringify({
                    count: this.extracount,
                }));
                this.extracount = this.extracount;
            }
        },

        nextlivery(){
            if(this.liverycount <= 17){
                this.liverycount += 1;
                $.post(`https://${GetParentResourceName()}/livery`, JSON.stringify({
                    count: this.liverycount,
                }));
                this.liverycount = this.liverycount;
            }
        },

        backlivery(){
            if(this.liverycount >= 0){
                this.liverycount -= 1;
                $.post(`https://${GetParentResourceName()}/livery`, JSON.stringify({
                    count: this.liverycount,
                }));
                this.liverycount = this.liverycount;
            }
        },

        apply(){
            $.post(`https://${GetParentResourceName()}/apply`, JSON.stringify({
                count: this.liverycount,
            }));
        },

        specs(data) {
            this.transfershows = false
            this.showspecs = true
            this.showsell = false
            this.comp = false
        },

        transfershow(data) {
            this.transfershows = true
            this.showspecs = false
            this.showsell = false
        },

        showcars(data) {
            this.showcar = true
            this.showmotor = false
            this.showbike = false
            this.showairs = false
            this.showboats = false
        },

        showmotorcycle(data) {
            
            this.showmotor = true
            this.showcar = false
            this.showbike = false
            this.showairs = false
            this.showboats = false
        },

        showbikes(data) {
            this.showbike = true
            this.showmotor = false
            this.showcar = false
            this.showairs = false
            this.showboats = false
        },

        
        showair(data) {
            this.showbike = false
            this.showmotor = false
            this.showcar = false
            this.showboats = false
            this.showairs = true
        },

        
        showboat(data) {
            this.showbike = false
            this.showmotor = false
            this.showcar = false
            this.showboats = true
        },

        sellshow(data) {
            this.transfershows = false
            this.showspecs = false
            this.showsell = true
        },

        checkVehicleClass(currentClass) {
            const classes = [0,1,2,3,4,5,6,7,9,10,11,12,17,18,19,20,22]
            let found = false
            classes.forEach((num) => {
                if (num == currentClass) {
                    found = true
                }
            })
            return found
        },

        checkAirClass(currentClass) {
            const classes = [15,16]
            let found = false
            classes.forEach((num) => {
                if (num == currentClass) {
                    found = true
                }
            })
            return found
        },

        spawnvehicle (data){
            if (this.lastplate != '') {
                if (data == 'normal') {
                    $.post(`https://${GetParentResourceName()}/spawnvehicle`, JSON.stringify({
                        model: this.model,
                        garage: this.garage,
                        vale: false,
                    }));
                    this.show = false;
                    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    
                } else if (data == 'vale') {
                    $.post(`https://${GetParentResourceName()}/spawnvehicle`, JSON.stringify({
                        model: this.model,
                        garage: this.garage,
                        vale: true,
                        
                    }),(data) => {
                        if(data) {
                            $.post(`https://${GetParentResourceName()}/spawnvehicle`, JSON.stringify({
                                model: this.model,
                                garage: this.garage,
                                vale: 2,
                            }));
                        }
                    });
                    this.show = false;
                    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    
                }else if (data == 'impound') {
                    $.post(`https://${GetParentResourceName()}/spawnvehicle`, JSON.stringify({
                        model: this.model,
                        garage: this.garage,
                        impound: true,
                        
                    }),(data) => {
                        if(data) {
                            $.post(`https://${GetParentResourceName()}/spawnvehicle`, JSON.stringify({
                                model: this.model,
                                garage: this.garage,
                                vale: 3,
                            }));
                        }
                    });
                    this.show = false;
                    $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
    
                }
            }
        },

        close() {
            this.show = false;
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        }
    }

})

function checkFileExist(urlToFile) {
    var xhr = new XMLHttpRequest();
    xhr.open('HEAD', urlToFile, false);
    xhr.send();

    if (xhr.status == "404") {
        return false;
    } else {
        return true;
    }
}

$(document).keydown(function(e) {
	if (e.keyCode == 27) {
		app.show = false;
        $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
	}
});

