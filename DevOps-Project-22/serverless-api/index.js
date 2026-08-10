require('dotenv').config();
const express = require("express");
const upload = require("express-fileupload");
const serverless = require("serverless-http");
const app = express();

app.disable("x-powered-by");
app.use(express.json({ limit: "1mb" }));
app.use(upload({
    abortOnLimit: true,
    limits: { fileSize: 5 * 1024 * 1024 }
}));

app.get("/healthz", (req, res) => {
    res.status(200).json({ Status: 200, Message: "Server is up and running." });
});

let routerPromise;

async function getRouter() {
    if (!routerPromise) {
        routerPromise = (async () => {
            const db = await require(__dirname + "/api/services/service.js");
            await Promise.all([
                require(__dirname + "/api/models/User.js"),
                require(__dirname + "/api/models/Product.js"),
                require(__dirname + "/api/models/ProductImage.js")
            ]);
            await db.sync();
            console.log("Database connection and schema initialization succeeded.");
            return require(__dirname + "/api/routes/routes.js");
        })().catch((error) => {
            routerPromise = undefined;
            throw error;
        });
    }

    return routerPromise;
}

app.use(async (req, res, next) => {
    try {
        const router = await getRouter();
        return router(req, res, next);
    } catch (error) {
        console.error("Application initialization failed:", error);
        return res.status(503).json({
            Status: 503,
            Message: "Application dependencies are unavailable."
        });
    }
});

const lambdaHandler = serverless(app);

if (process.env.ENVIRONMENT === "lambda") {
    module.exports.handler = async (event, context) => {
        context.callbackWaitsForEmptyEventLoop = false;
        return lambdaHandler(event, context);
    };
} else if (require.main === module) {
    const port = Number(process.env.PORT || 3000);
    app.listen(port, () => {
        console.log(`Server started on port:${port}`);
    });
}

module.exports.app = app;
