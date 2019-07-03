import { SubscriptionResolvers } from "../gen/resolvers";
import { SaleContractModel } from "../db";
import { PubSub } from "graphql-yoga-dgt";

const asyncify = require("callback-to-async-iterator");
export const Subscription: SubscriptionResolvers<{ pubsub: PubSub }> = {
  salesInItem: {
    subscribe: (parent, args, { pubsub }, info) => {
      // TODO isso não deve estar muito otimizado
      const changeStream = SaleContractModel.collection.watch();

      changeStream.on("change", async change => {
        const contract = await SaleContractModel.findById(
          change.documentKey._id,
        );

        if (contract == null) {
          return;
        }

        const history = contract.history[contract.history.length - 1];
        pubsub.publish(contract._selling as any, { salesInItem: history });
      });

      return pubsub.asyncIterator(args.itemId);
    },
  },
};
