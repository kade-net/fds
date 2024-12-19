import {pgTable, timestamp, varchar, boolean} from "drizzle-orm/pg-core";
import {relations} from "drizzle-orm/relations";

export const ACCOUNT = pgTable("ACCOUNT", {
    address: varchar("address").unique().notNull().primaryKey(),
    displayName: varchar("displayName"),
    pfp: varchar("pfp"),
    bio: varchar("bio"),
    email: varchar("email"),
    phone: varchar("phone"),
    createdAt: timestamp("createdAt").defaultNow()
})

export const ACCOUNT_CHAIN = pgTable("ACCOUNT_CHAIN", {
    rkey: varchar("rkey").unique().notNull().primaryKey(),
    address: varchar("address").notNull().references(()=> ACCOUNT.address),
    chain: varchar("chain").notNull(),
    publicKey: varchar("publicKey").notNull(),
    scheme: varchar("scheme").notNull(),
    nsName: varchar("nsName").notNull(),
    createdAt: timestamp("createdAt").defaultNow()
})

export const ACCOUNT_PASSWORD = pgTable("ACCOUNT_PASSWORD", {
    rkey: varchar("rkey").unique().notNull().primaryKey(),
    address: varchar("address").notNull().references(()=> ACCOUNT.address),
    passwordSalt: varchar("passwordSalt").notNull(),
    createdAt: timestamp("createdAt").defaultNow()
})

export const ACCOUNT_VERIFICATION = pgTable("ACCOUNT_VERIFICATION", {
    rkey: varchar("rkey").unique().notNull().primaryKey(),
    address: varchar("address").notNull().references(()=> ACCOUNT.address),
    token: varchar("token").notNull(),
    verificationMethod: varchar("verificationMethod").notNull(),
    verified: boolean("verified").default(false),
    createdAt: timestamp("createdAt").defaultNow(),
    verifiedAt: timestamp("verifiedAt")
})

export const ACCOUNT_AUTH_TOKENS = pgTable("ACCOUNT_AUTH_TOKENS", {
    rkey: varchar("rkey").unique().notNull().primaryKey(),
    address: varchar("address").notNull().references(()=> ACCOUNT.address),
    type: varchar("type").notNull(),
    key: varchar("key").notNull(),
    createdAt: timestamp("createdAt").defaultNow(),
})


export const ACCOUNT_KEYPAIR = pgTable("ACCOUNT_KEYPAIR", {
    rkey: varchar("rkey").unique().notNull().primaryKey(),
    address: varchar("address").notNull().references(()=> ACCOUNT.address),
    privateKey: varchar("encryptedPrivateKey").notNull(), // INFO: these are not the same as the user's chain wallet key pair, these are ed25519 keypairs only used for generating signature for records before submitting them to the FIREHOSE and not wallets
    publicKey: varchar("publicKey").notNull(),
    createdAt: timestamp("createdAt").defaultNow(),
    disabledAt: timestamp("disabledAt").defaultNow()
})

export const ACCOUNT_CHAIN_relations = relations(ACCOUNT_CHAIN, (ops)=>({
    account: ops.one(ACCOUNT, {
        fields: [ACCOUNT_CHAIN.address],
        references: [ACCOUNT.address],
    })
}))


export const ACCOUNT_PASSWORD_relations = relations(ACCOUNT_PASSWORD, (ops)=>({
    account: ops.one(ACCOUNT, {
        fields: [ACCOUNT_PASSWORD.address],
        references: [ACCOUNT.address],
    })
}))


export const ACCOUNT_VERIFICATION_relations = relations(ACCOUNT_VERIFICATION, (ops)=>({
    account: ops.one(ACCOUNT, {
        fields: [ACCOUNT_VERIFICATION.address],
        references: [ACCOUNT.address],
    })
}))

export const ACCOUNT_AUTH_TOKENS_relations = relations(ACCOUNT_AUTH_TOKENS, ops => ({
    account: ops.one(ACCOUNT,{
        fields: [ACCOUNT_AUTH_TOKENS.address],
        references: [ACCOUNT.address],
    })
}))

export const ACCOUNT_KEYPAIR_relations = relations(ACCOUNT_KEYPAIR, ops => ({
    account: ops.one(ACCOUNT, {
        fields: [ACCOUNT_KEYPAIR.address],
        references: [ACCOUNT.address],
    })
}))