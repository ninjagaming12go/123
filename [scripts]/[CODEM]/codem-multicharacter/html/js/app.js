
import inlinesvg from './util/inlinesvg.js';
import localeEn from "./en.js";
const store = Vuex.createStore({
    components: {
        inlinesvg: inlinesvg,

    },
    state: {},
    getters: {},
    mutations: {},
    actions: {}
});

const app = Vue.createApp({
    components: {
        inlinesvg: inlinesvg,
    },
    data: () => ({
        selectpage: 'selectplayer',
        newCharacter: false,
        createModal: false,
        buyCharacter: false,
        tbxID: "Your tbx-id...",
        selectedCharacter: false,
        characterData: [],
        serverlogo: "https://r2.fivemanage.com/8Hb4twhFSbaNdR27bPGV4/m_logo.png",
        maxSlots: [],
        selectedGender: 'male',
        characterInfo: {
            firstname: '',
            lastname: '',
            birthdate: false,
            height: 150,
            nationality: 'USA'
        },
        playerActiveSlots: false,
        characterIndex: 0,
        myCharacter: [],
        lastLocation: null,
        deleteCharacterButton: false,
        currentThema: 'white',
        isChanging: false, 
        locales: [],
        moneyType: '$',
        closeServerModal: false,
        deleteCharacterModal: false,
        clickedCountine : false,
    }),
    methods: {
        continuePlayer() {
            const character = this.characterData[this.characterIndex];
            if (character && !this.clickedCountine) {
                this.clickedCountine = true;
                postNUI('continuePlayer', character);
            }
            this.characterIndex = 0;
        },
        
        async ChangeCharacter(direction) {
            if (this.isChanging) return;
            this.isChanging = true;
            if (this.characterIndex === this.maxSlots.length - 1 && direction === 'next') {
                this.isChanging = false;
                return;
            }
            if (direction === 'next' && this.characterIndex < this.maxSlots.length - 1) {
                this.characterIndex++;
                const character = this.characterData[this.characterIndex];
                if (character) {
                    this.SelectCharacter(character)
                    return this.myCharacter = { ...character, label: `${character.charinfo.firstname} ${character.charinfo.lastname}`, isNew: false, isBuy: false };
                } else if (this.maxSlots[this.characterIndex]?.tebex) {
                    this.buyCharacter = true
                    postNUI('newCharacter')
                    this.selectedCharacter = false
                    this.newCharacter = false
                    setTimeout(() => {
                        this.isChanging = false; 
                    }, 400);
                    return this.myCharacter = { label: this.locales["BUYSLOTJS"], isNew: false, isBuy: true };

                }
                postNUI('newCharacter')
                this.selectedCharacter = false
                this.buyCharacter = false
                this.newCharacter = true
                setTimeout(() => {
                    let nowData = new Date();
                    this.$nextTick(() => {
                        let vm = this;
                        let dp = new AirDatepicker("#pickerinput", {
                            locale: localeEn,
                            maxDate: nowData,
                            onSelect({ date, formattedDate }) {
                                vm.characterInfo.birthdate = formattedDate
                            },
                        });
                    });

                }, 600);

                setTimeout(() => {
                    this.isChanging = false; 
                }, 400);
                return this.myCharacter = { label: this.locales["NEW_CHARACTER_JS"] , isNew: true, isBuy: false };
            } else if (direction === 'previus' && this.characterIndex > 0) {
               
                this.characterIndex--;
                const character = this.characterData[this.characterIndex];
                if (character) {
                    this.SelectCharacter(character)
                    return this.myCharacter = { ...character, label: `${character.charinfo.firstname} ${character.charinfo.lastname}`, isNew: false, isBuy: false };
                } else if (this.maxSlots[this.characterIndex]?.tebex) {
                    postNUI('newCharacter')
                    this.buyCharacter = true
                    this.selectedCharacter = false
                    this.newCharacter = false
                    setTimeout(() => {
                        this.isChanging = false; 
                    }, 400);
                    return this.myCharacter = { label: this.locales["BUYSLOTJS"], isNew: false, isBuy: true };
                }
                postNUI('newCharacter')
                this.selectedCharacter = false
                this.buyCharacter = false
                this.newCharacter = true
                setTimeout(() => {
                    let nowData = new Date();
                    this.$nextTick(() => {
                        let vm = this;
                        let dp = new AirDatepicker("#pickerinput", {
                            locale: localeEn,
                            maxDate: nowData,
                            onSelect({ date, formattedDate }) {
                                vm.characterInfo.birthdate = formattedDate
                            },
                        });
                    });
                }, 600);
                setTimeout(() => {
                    this.isChanging = false; 
                }, 400);
                return this.myCharacter = { label: this.locales["NEW_CHARACTER_JS"], isNew: true, isBuy: false };
            }
            
            this.clickedCountine = false;
        },
        validateBirthdateInput(event) {
            const char = String.fromCharCode(event.keyCode);
            const regex = /[0-9]|\/|/;
            if (!regex.test(char)) {
                event.preventDefault();
            }
            const value = event.target.value;
            this.characterInfo.birthdate = value
            if (value.length === 2 || value.length === 5) {
                if (event.keyCode !== 47) {
                    event.target.value = value + '/';

                }
            }
        },
        checkInputMin() {
            if (this.characterInfo.firstname.length > 0) {
                this.characterInfo.firstname = this.characterInfo.firstname.replace(/[^a-zA-Z]/g, "");
            }
            if (this.characterInfo.lastname.length > 0) {
                this.characterInfo.lastname = this.characterInfo.lastname.replace(/[^a-zA-Z]/g, "");
            }
            // if (this.characterInfo.height.length > 0) {
            //     this.characterInfo.height = this.characterInfo.height.replace(/[^0-9]/g, "");
            // }
        },
        changeGender(val) {
            this.selectedGender = val
        },
        async deleteCharacter() {
            if (this.selectedCharacter) {
                let result = await postNUI('DeleteCharacter', this.selectedCharacter)
                if (result) {
                    this.selectedCharacter = false
                    this.characterData = result
                    const character = this.characterData[this.characterIndex];
                    if (character) {
                        this.SelectCharacter(character)
                        return this.myCharacter = { ...character, label: `${character.charinfo.firstname} ${character.charinfo.lastname}`, isNew: false, isBuy: false };
                    } else if (this.maxSlots[this.characterIndex]?.tebex) {
                        postNUI('newCharacter')
                        this.selectedCharacter = false
                        this.newCharacter = false
                        this.buyCharacter = true
                        setTimeout(() => {
                            this.isChanging = false; 
                        }, 400);
                        return this.myCharacter = { label: this.locales["BUYSLOTJS"], isNew: false, isBuy: true };
                    }
                    postNUI('newCharacter')
                    this.selectedCharacter = false
                    this.buyCharacter = false
                    this.newCharacter = true
                    setTimeout(() => {
                        let nowData = new Date();
                        this.$nextTick(() => {
                            let vm = this;
                            let dp = new AirDatepicker("#pickerinput", {
                                locale: localeEn,
                                maxDate: nowData,
                                onSelect({ date, formattedDate }) {
                                    vm.characterInfo.birthdate = formattedDate
                                },
                            });
                        });
                    }, 600);
                    setTimeout(() => {
                        this.isChanging = false; 
                    }, 400);
                    this.myCharacter = { label: this.locales["NEW_CHARACTER_JS"], isNew: true, isBuy: false };
                } else {
                    console.log('error')
                }
            }
        },
        async SelectCharacter(val) {
            this.newCharacter = false
            this.selectedCharacter = false
            this.buyCharacter = false
            this.isChanging = true;
            let result = await postNUI('SelectCharacter', val)
            if (result) {
                setTimeout(() => {
                    this.selectedCharacter = val
                }, 400);

            } else {
                console.log('error')
            }
            setTimeout(() => {
                this.isChanging = false;
            }, 400);
        },
        CreateNewCharacter() {
            this.selectedCharacter = false
            this.buyCharacter = false
            postNUI('newCharacter')

            setTimeout(() => {
                this.newCharacter = true
            }, 400);
            
        },
        openCreateModal() {
            this.createModal = true
        },
        checkTebex(){
            postNUI("checkTebex", {
                tbxid: this.tbxID,
            });
            this.createModal = false
        },
        CreateCharacter() {
            if (this.buyCharacter) {
                this.createModal = true
                return
            }
            if (this.characterInfo.firstname.length < 3 || this.characterInfo.lastname.length < 3 || this.characterInfo.birthdate == false || this.characterInfo.height < 121 || this.characterInfo.height > 199) return
            postNUI("createChar", {
                firstname: this.characterInfo.firstname,
                lastname: this.characterInfo.lastname,
                nationality: this.characterInfo.nationality,
                birthdate: this.characterInfo.birthdate,
                height: this.characterInfo.height,
                gender: this.selectedGender,
                cid: this.characterIndex,
            });

            this.characterIndex = 0;
            this.characterInfo = {
                firstname: '',
                lastname: '',
                birthdate: false,
                height: 150,
            }
        },
        checkPage(val) {
            if (this.createModal) {
                return false;
            }
            if (val === 'mychar') {
                return !this.newCharacter && this.selectedCharacter;
            }
            if (val === 'createchar') {
                if (this.newCharacter || this.buyCharacter) {
                    return true;
                } 
            }
        },
        checkModal(val) {
            if (val === 'tebex') {
                return this.createModal;
            } else if (val === 'quitServerModal') {
                return this.closeServerModal;

            } else if (val === 'deleteCharacterModal') {
                return this.deleteCharacterModal;
            } else if (val === 'none') {
                if (this.createModal || this.closeServerModal || this.deleteCharacterModal) {
                    return false;
                } else {
                    return true;
                }
            }
        },

        clickModal(val, val2) {
            if (val === 'closeServer') {
                this.closeServerModal = !this.closeServerModal;
                if (val2) {
                    postNUI('closeAndDropPlayer')
                }
            } else if (val === 'deleteCharacter') {
                this.deleteCharacterModal = !this.deleteCharacterModal;
                if (val2) {
                    this.deleteCharacter()
                }
            } else if (val === 'openDelete') {
                this.deleteCharacterModal = true;
            }
        },
        updateMaxSlots(playerActiveSlots) {
            if (playerActiveSlots === 0) {
                return;
            }
            let tebexCount = 0;
            for (const slot of this.maxSlots) {
                if (slot.tebex) {
                    slot.tebex = false;
                    tebexCount++;
                    if (tebexCount === playerActiveSlots) {
                        break;
                    }
                }
            }
        },
        eventHandler(event) {
            switch (event.data.action) {
                case "CHECK_NUI":
                    postNUI('LoadedNUI')
                    break;
                case "ShowUI":
                    this.characterIndex = 0;
                    this.clickedCountine = false;
                    document.querySelector('#app').style.display = 'block'
                    break;
                case "LOADED_ADD_SLOTS":
                    this.maxSlots = event.data.payload.maxSlots;
                    this.playerActiveSlots = event.data.payload.activeSlots;
                    this.updateMaxSlots(this.playerActiveSlots);
                break;
                case "LOADED_PLAYER_DATA":
                    this.characterData = event.data.payload;
                    const character = this.characterData[this.characterIndex];
                    if (character) {
                        this.SelectCharacter(character)
                        return this.myCharacter = { ...character, label: `${character.charinfo.firstname} ${character.charinfo.lastname}`, isNew: false, isBuy: false };
                    } else if (this.maxSlots[this.characterIndex]?.tebex) {
                        postNUI('newCharacter')
                        this.selectedCharacter = false
                        this.newCharacter = false
                        this.buyCharacter = true
                        setTimeout(() => {
                            this.isChanging = false; 
                        }, 400);
                        return this.myCharacter = { label: this.locales["BUYSLOTJS"] , isNew: false, isBuy: true };
                    }
                    postNUI('newCharacter')
                    this.selectedCharacter = false
                    this.buyCharacter = false 
                    this.newCharacter = true
                    setTimeout(() => {
                        let nowData = new Date();
                        this.$nextTick(() => {
                            let vm = this;
                            let dp = new AirDatepicker("#pickerinput", {
                                locale: localeEn,
                                maxDate: nowData,
                                onSelect({ date, formattedDate }) {
                                    vm.characterInfo.birthdate = formattedDate
                                },
                            });
                        });
                    }, 600);
                    setTimeout(() => {
                        this.isChanging = false; 
                    }, 400);
                    this.myCharacter = { label: this.locales["NEW_CHARACTER_JS"], isNew: true, isBuy: false };
                    break;
                case "LOAD_CONFIG_DATA":
                    // this.maxSlots = event.data.payload.slot
                    this.deleteCharacterButton = event.data.payload.deletecharacter
                    this.currentThema = event.data.payload.thema
                    this.serverlogo = event.data.payload.serverLogo
                    this.locales = event.data.payload.locales
                    this.moneyType = event.data.payload.moneyType
                    break;
                case "UPDATE_LAST_LOCATION":
                    this.lastLocation = event.data.payload;
                    break;
                case "closeNUI":
                    document.querySelector('#app').style.display = 'none'
                    break;
                default:
                    break;
            }
        },
        updateHeight(value) {
            const parsedValue = parseInt(value);
            if (!isNaN(parsedValue)) {
                if (value.length > 3) {
                    this.characterInfo.height = value.slice(0, 3);
                    return;
                } else {
                    this.characterInfo.height = parsedValue;
                }
            } else {
                this.characterInfo.height = '';
            }
        },
    },

    computed: {
    },
    mounted() {
        window.addEventListener('message', this.eventHandler);
        window.addEventListener('keyup', (event) => {
            if (event.key === "Escape") {
                if (this.createModal) {
                    this.createModal = false;
                } else {
                    this.closeServerModal = !this.closeServerModal;
                    // postNUI('closeAndDropPlayer')
                }
            }
        });
        setInterval(() => {
            if (this.isChanging ) {
                this.isChanging = false;
            }
        }, 10000);
    },
    watch: {
        'characterInfo.height'(newVal) {
            this.updateHeight(newVal);
        },
    },
});

app.use(store).mount("#app");


var resourceName = "codem-multicharacter";

if (window.GetParentResourceName) {
    resourceName = window.GetParentResourceName();
}

window.postNUI = async (name, data) => {
    try {
        const response = await fetch(`https://${resourceName}/${name}`, {
            method: "POST",
            mode: "cors",
            cache: "no-cache",
            credentials: "same-origin",
            headers: {
                "Content-Type": "application/json"
            },
            redirect: "follow",
            referrerPolicy: "no-referrer",
            body: JSON.stringify(data)
        });
        return !response.ok ? null : response.json();
    } catch (error) {
    }
};

function clicksound(val) {
    if (!soundFx) return;
    let audioPath = `./sound/${val}`;
    audioPlayer = new Howl({
        src: [audioPath]
    });
    audioPlayer.volume(0.8);
    audioPlayer.play();
}
