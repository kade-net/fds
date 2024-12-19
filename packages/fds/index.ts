import * as http from "node:http";
import { Options as XrpcServerOptions } from '@atproto/xrpc-server'
import {createServer} from "server";
import API from "./api";
import express, {Express} from "express";
import cors from "cors";

export class FDS {
    public server?: http.Server;
    public app: Express;
    constructor(app: Express){
        this.app = app;
    }


    static async create() {

        const xrpcOptions: XrpcServerOptions = {
            validateResponse: false,
            payload: {
                jsonLimit: 150 * 1024, // 150kb
                textLimit: 150 * 1024,
                blobLimit: 10 * 1024 * 1024, // 10mb // TODO: confirm this is 10 mb
            },
            catchall: (error)=>{
                console.log(error)
                // refine error handler
            },
        }

        let server = createServer(xrpcOptions);

        server = API(server)

        const app = express()

        app.set('trust proxy', true)
        app.use(cors())
        app.use(express.json())
        app.use(server.xrpc.router)

        return new FDS(app)
    }
}

export default FDS