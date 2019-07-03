import { Query } from "./resolvers/queries";
import { Mutation } from "./resolvers/mutations";
import { Identity } from "./resolvers/identity";
import { Account } from "./resolvers/account";
import { SaleContract } from "./resolvers/sale_contract";
import { SaleHistory } from "./resolvers/sale_history";
import { SalePutHistory } from "./resolvers/sale_put_history";
import { Subscription } from "./resolvers/subscriptions";
import { ItemForSale } from "./resolvers/item_for_sale";
import { Options } from "graphql-yoga-dgt/dist/types";
import { GraphQLServer, PubSub } from "graphql-yoga-dgt";
import { BackContext } from "./types";
import * as jwt from "jsonwebtoken";
import { JWT_SECRET } from "./constants";
import { SaleContractModel } from "./db";

const baseOptions: Options = {
  endpoint: "/api",
  playground: "/api",
  subscriptions: "/api",
};
const pubsub = new PubSub();

const server = new GraphQLServer({
  context: ({ request }): BackContext => {
    let userId = "";
    let role: "none" | "account" | "identity" = "none";
    try {
      const decoded = jwt.verify(
        String(request.headers["authentication"]),
        JWT_SECRET,
      );
      userId = (decoded as any).id;
      role = (decoded as any).role as any;
    } catch (err) {
      // console.error(err);
    }
    return {
      pubsub,
      userId,
      role,
    };
  },
  typeDefs: __dirname + "/schema.graphql",
  resolvers: {
    Subscription,
    ItemForSale,
    SalePutHistory,
    SaleHistory,
    Account,
    Identity,
    SaleContract,
    Query,
    Mutation,
  } as any, // TODO: remover o any
});

if (process.env.LOCAL === "LOCAL") {
  server.start(
    {
      ...baseOptions,
      port: 4000,
    },
    () => {
      console.log("Running locally on port 4000");
    },
  );
} else {
  module.exports = server.createExpressApplication(baseOptions);
}
// module.exports = server.createExpressApplication(baseOptions);
