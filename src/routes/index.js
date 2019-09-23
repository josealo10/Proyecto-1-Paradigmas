const express = require("express")
const router = express.Router()

router.get('/',(rep,res) => {
    res.render('index',{
        title: 'Chat'
    })
})

module.exports = router