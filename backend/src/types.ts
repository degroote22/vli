import { PubSub } from "graphql-yoga-dgt";

export interface BackContext {
  pubsub: PubSub;
  userId: string;
  role: "account" | "identity" | "none";
}
