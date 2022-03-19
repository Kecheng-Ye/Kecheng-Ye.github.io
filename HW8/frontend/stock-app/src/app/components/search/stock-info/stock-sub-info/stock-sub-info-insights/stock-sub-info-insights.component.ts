import { Component, OnInit } from '@angular/core';
import { StockQueryService } from '../../../../../services/stock-query.service';
import { SearchUpdateService } from '../../../../../services/search-update.service';
import { PreviousStateService } from '../../../../../services/previous-state.service';
import { forkJoin, of, switchMap, take } from "rxjs";
import {
  Earning_Info,
  Insights_Info,
  Recommend_Info,
  Sentiments_For_Plot,
  Social_Sentiment,
  Social_Sentiment_List,
} from '../../../../../data_interface/stock_sub_info';
import { Company_Brief } from "../../../../../data_interface/stock_main_info";

@Component({
  selector: 'app-stock-sub-info-insights',
  templateUrl: './stock-sub-info-insights.component.html',
  styleUrls: ['./stock-sub-info-insights.component.css'],
})
export class StockSubInfoInsightsComponent implements OnInit {
  ticker: string = '';
  is_loading = true;
  insights_data: Insights_Info = {
    social_sentiments: {
      reddit: {total_mention: 0, negative: 0, positive: 0},
      twitter: {total_mention: 0, negative: 0, positive: 0},
      name: "",
    },
    recommends: [],
    earnings: [],
  } as Insights_Info;

  constructor(
    private stock_query: StockQueryService,
    private ticker_query: SearchUpdateService,
    private prev_info_query: PreviousStateService
  ) {}

  joined_query_list = () => {
    this.is_loading = true;
    return forkJoin([
      this.stock_query.get_social_sentiments_lst(this.ticker),
      this.stock_query.get_recommend_info_lst(this.ticker),
      this.stock_query.get_earning_lst(this.ticker),
      this.prev_info_query.get_prev_main_info().pipe(take(1)),
    ]);
  };

  retrieve_data = (result: any) => {
    if (Array.isArray(result)) {
      this.retrieve_query(result);
    } else {
      this.insights_data = result;
    }

    this.is_loading = false;
  };

  retrieve_query = (result: any) => {
    const [social_sentiments, recommend, earning, brief] = result;

    this.retrieve_social_sentiments(social_sentiments, brief.name);
    this.retrieve_recommend_lst(recommend);
    this.retrieve_earning_lst(earning);

    this.prev_info_query.update_insights_info(this.insights_data);
  };

  retrieve_social_sentiments = (social_sentiments: Social_Sentiment_List, brief: Company_Brief) => {
    this.retrieve_single_social_sentiments(
      social_sentiments.reddit,
      this.insights_data.social_sentiments.reddit
    );

    this.retrieve_single_social_sentiments(
      social_sentiments.twitter,
      this.insights_data.social_sentiments.twitter
    );

    this.insights_data.social_sentiments.name = brief.name;
  };

  retrieve_single_social_sentiments = (
    single_lst: Social_Sentiment[],
    aggregate_result: Sentiments_For_Plot
  ) => {
    const n = single_lst.length;
    for (let i = 0; i < n; i++) {
      const one_record = single_lst[i];
      aggregate_result.total_mention += one_record.mention;
      aggregate_result.positive += one_record.positiveMention;
      aggregate_result.negative += one_record.negativeMention;
    }
  };

  retrieve_recommend_lst = (recommend: Recommend_Info[]) => {
    this.insights_data.recommends = recommend;
  };

  retrieve_earning_lst = (earning: Earning_Info[]) => {
    this.insights_data.earnings = earning;
  };

  ngOnInit(): void {
    this.ticker_query
      .fetch_ticker()
      .pipe(
        switchMap(([ticker, ticker_change]) => {
          this.ticker = ticker;
          if (ticker_change) {
            return this.joined_query_list();
          } else {
            return this.prev_info_query.get_insights_info();
          }
        })
      )
      .subscribe(this.retrieve_data);
  }
}
