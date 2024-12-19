import {Server} from "server";
import createAccount from "./createAccount";

export default function (server: Server){
    createAccount(server);
    return server
}